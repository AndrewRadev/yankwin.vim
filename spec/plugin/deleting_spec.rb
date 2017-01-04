require 'spec_helper'

describe "Deleting windows" do
  specify "with different registers" do
    vim.command 'edit first.txt'
    vim.command 'split second.txt'
    vim.command 'split third.txt'

    vim.feedkeys '"a\<c-w>d'
    vim.feedkeys '"b\<c-w>d'

    register_contents = get_register('a')
    expect(register_contents).to eq 'third.txt'

    register_contents = get_register('b')
    expect(register_contents).to eq 'second.txt'
  end

  context "in a split" do
    before :each do
      vim.command 'edit first.txt'
      vim.command 'split second.txt'
    end

    specify "relative path" do
      vim.feedkeys '\<c-w>d'

      expect(get_windows).to eq ['first.txt']
      expect(get_register('"')).to eq 'second.txt'
    end

    specify "absolute path" do
      vim.feedkeys '\<c-w>gd'

      expect(get_windows).to eq ['first.txt']
      expect(get_register('"')).to eq File.expand_path('second.txt')
    end
  end

  context "in a tab" do
    before :each do
      vim.command 'edit first.txt'
      vim.command 'tabnew second.txt'
    end

    specify "relative path" do
      vim.feedkeys '\<c-w>d'

      expect(get_windows).to eq ['first.txt']
      expect(get_register('"')).to eq 'second.txt'
    end

    specify "absolute path" do
      vim.feedkeys '\<c-w>gd'

      expect(get_windows).to eq ['first.txt']
      expect(get_register('"')).to eq File.expand_path('second.txt')
    end
  end

  context "with line numbers" do
    before :each do
      vim.command 'edit first.txt'
      vim.command 'split second.txt'
      vim.normal 'ggdG'
      vim.insert 'one<cr>two<cr>three'
      vim.write
      vim.search 'two'
    end

    specify "relative path with line numbers" do
      vim.feedkeys '\<c-w>D'

      register_contents = get_register('"')
      expect(register_contents).to eq 'second.txt:2'
    end

    specify "absolute path with line numbers" do
      vim.feedkeys '\<c-w>gD'

      register_contents = get_register('"')
      expect(register_contents).to eq File.expand_path('second.txt:2')
    end
  end
end
