module Support
  module Vim
    def get_tab_pages
      last_tab_page = vim.command("echo tabpagenr('$')").to_i

      (1 .. last_tab_page).map do |tabnr|
        winnr = vim.command("echo tabpagewinnr(#{tabnr})")
        vim.command("tabnext #{tabnr}")
        vim.command("#{winnr}wincmd w")
        vim.command("echo bufname('%')")
      end
    end

    def get_windows
      last_window = vim.command("echo winnr('$')").to_i

      (1 .. last_window).map do |winnr|
        vim.command("#{winnr}wincmd w")
        vim.command("echo bufname('%')")
      end
    end

    def get_register(identifier)
      vim.echo "getreg('#{identifier.gsub("'", "''")}')"
    end

    def set_register(identifier, value)
      escaped_identifier = identifier.gsub("'", "''")
      escaped_value      = value.gsub("'", "''")

      vim.command "call setreg('#{escaped_identifier}', '#{escaped_value}')"
    end
  end
end
