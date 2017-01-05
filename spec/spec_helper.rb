require 'vimrunner'
require 'vimrunner/rspec'
require_relative './support/vim'

Vimrunner::RSpec.configure do |config|
  config.reuse_server = true

  plugin_path = File.expand_path('.')

  config.start_vim do
    vim = Vimrunner.start_gvim
    vim.add_plugin(plugin_path, 'plugin/pastewin.vim')
    vim
  end
end

RSpec.configure do |config|
  config.include Support::Vim

  config.before :each do
    # Reset window state before each test
    vim.command 'new'
    vim.command 'only'
    vim.command 'tabonly'
    vim.command 'set clipboard='
  end
end
