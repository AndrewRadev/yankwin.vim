require 'spec_helper'

describe "Yanking windows" do
  specify "relative path" do
    vim.command 'edit first.txt'
    vim.feedkeys '\<c-w>y'

    register_contents = get_register('"')
    expect(register_contents).to eq 'first.txt'
  end

  specify "absolute path" do
    vim.command 'edit first.txt'
    vim.feedkeys '\<c-w>gy'

    register_contents = get_register('"')
    expect(register_contents).to eq File.expand_path('first.txt')
  end

  specify "with different registers" do
    vim.command 'edit first.txt'
    vim.feedkeys '"a\<c-w>y'
    vim.command 'edit second.txt'
    vim.feedkeys '"b\<c-w>y'
    vim.command 'edit third.txt'
    vim.feedkeys '\<c-w>y'

    register_contents = get_register('a')
    expect(register_contents).to eq 'first.txt'

    register_contents = get_register('b')
    expect(register_contents).to eq 'second.txt'

    register_contents = get_register('"')
    expect(register_contents).to eq 'third.txt'
  end

  context "with line numbers" do
    before :each do
      vim.command 'edit first.txt'
      vim.normal 'ggdG'
      vim.insert 'one<cr>two<cr>three'
      vim.write
      vim.search 'two'
    end

    specify "relative path with line numbers" do
      vim.feedkeys '\<c-w>Y'

      register_contents = get_register('"')
      expect(register_contents).to eq 'first.txt:2'
    end

    specify "absolute path with line numbers" do
      vim.feedkeys '\<c-w>gY'

      register_contents = get_register('"')
      expect(register_contents).to eq File.expand_path('first.txt:2')
    end
  end
end
