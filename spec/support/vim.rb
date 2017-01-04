module Support
  module Vim
    def get_buffer_list
      entries = vim.command('ls a').split("\n")
      entries.map do |entry|
        entry.gsub(/^.*?"(.*)".*$/, '\1')
      end
    end

    def get_register(identifier)
      vim.command "echo getreg('#{identifier.gsub("'", "''")}')"
    end

    def set_register(identifier, value)
      escaped_identifier = identifier.gsub("'", "''")
      escaped_value      = value.gsub("'", "''")

      vim.command "call setreg('#{escaped_identifier}', '#{escaped_value}')"
    end
  end
end
