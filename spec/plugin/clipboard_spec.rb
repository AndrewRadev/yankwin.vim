require 'spec_helper'

describe "Different 'clipboard' settings" do
  before :each do
    vim.command 'edit first.txt'
    set_register('+', '')
    set_register('*', '')
  end

  specify "clipboard=" do
    vim.command('set clipboard=')
    vim.feedkeys '\<c-w>y'

    expect(get_register('*')).to eq ''
    expect(get_register('+')).to eq ''
  end

  specify "clipboard=unnamed" do
    vim.command('set clipboard=unnamed')
    vim.feedkeys '\<c-w>y'

    expect(get_register('*')).to eq 'first.txt'
    expect(get_register('+')).to eq ''
  end

  specify "clipboard=unnamedplus" do
    vim.command('set clipboard=unnamedplus')
    vim.feedkeys '\<c-w>y'

    expect(get_register('*')).to eq ''
    expect(get_register('+')).to eq 'first.txt'
  end

  specify "clipboard=unnamed,unnamedplus" do
    vim.command('set clipboard=unnamed,unnamedplus')
    vim.feedkeys '\<c-w>y'

    expect(get_register('*')).to eq 'first.txt'
    expect(get_register('+')).to eq 'first.txt'
  end

  specify "clipboard=, with custom yank clipboard setting" do
    vim.command('set clipboard=')
    vim.command('let g:yankwin_yank_clipboard = "unnamed,unnamedplus"')
    vim.feedkeys '\<c-w>y'

    expect(get_register('*')).to eq 'first.txt'
    expect(get_register('+')).to eq 'first.txt'
  end
end
