require 'spec_helper'

describe "Pasting windows" do
  context "locations" do
    before do
      vim.edit 'first.txt'
      set_register('"', 'second.txt')
    end

    specify "in the current window" do
      vim.feedkeys '\<c-w>\<c-p>'
      expect(get_windows).to eq ['second.txt']
    end

    specify "to a split above" do
      vim.feedkeys '\<c-w>P'
      expect(get_windows).to eq ['second.txt', 'first.txt']
    end

    specify "to a split below" do
      vim.feedkeys '\<c-w>p'
      expect(get_windows).to eq ['first.txt', 'second.txt']
    end

    specify "to a previous tab" do
      vim.feedkeys '\<c-w>gP'
      expect(get_tab_pages).to eq ['second.txt', 'first.txt']
    end

    specify "to the next tab" do
      vim.feedkeys '\<c-w>gp'
      expect(get_tab_pages).to eq ['first.txt', 'second.txt']
    end

    specify "with a different register" do
      set_register('a', 'third.txt')
      vim.feedkeys '"a\<c-w>\<c-p>'
      expect(get_windows).to eq ['third.txt']
    end
  end

  context "paste processors" do
    before :each do
      write_file 'first.txt', <<-EOF
        one
        two
        three
      EOF
      vim.edit 'second.txt'
    end

    specify "line" do
      set_register('"', 'first.txt:2')
      vim.feedkeys '\<c-w>\<c-p>'

      expect(vim.echo('expand("%")')).to eq 'first.txt'
      expect(vim.echo('line(".")')).to eq "2"
    end

    specify "line and column" do
      set_register('"', 'first.txt:2:3')
      vim.feedkeys '\<c-w>\<c-p>'

      expect(vim.echo('expand("%")')).to eq 'first.txt'
      expect(vim.echo('line(".")')).to eq "2"
      expect(vim.echo('col(".")')).to eq "3"
    end

    specify "github url" do
      set_register('"', 'https://github.com/user/repo/blob/master/first.txt#L2-L9')
      vim.feedkeys '\<c-w>\<c-p>'

      expect(vim.echo('expand("%")')).to eq 'first.txt'
      expect(vim.echo('line(".")')).to eq "2"
    end
  end
end
