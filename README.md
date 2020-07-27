[![Build Status](https://secure.travis-ci.org/AndrewRadev/yankwin.vim.png?branch=master)](http://travis-ci.org/AndrewRadev/yankwin.vim)

## Usage

This plugin provides a set of mappings to delete, yank, and paste windows in a similar way that normal text is yanked and pasted around. This is done simply by yanking the window's path in the given register (which means this doesn't really work for special buffers like the quickfix window).

All the mappings are prefixed with `<c-w>` and attempt to be consistent both internally and with similar mappings in Vim. For instance, if you wanted to move a buffer from one tab to the other, you could delete it from its location with `<c-w>d` and then paste it in the right tab with `<c-w>p`.

**Note that some of these mappings override built-ins!** The following mappings already exist:

- `<c-w>d`:     (deleting) Opens a new window with the definition of the current macro
- `<c-w><c-p>`: (pasting) Goes to the last-accessed window
- `<c-w>p`:     (pasting) Goes to the last-accessed window
- `<c-w>P`:     (pasting) Goes to the preview window

If these mappings are important to your workflow, you can disable the overrides, either by setting `g:yankwin_default_mappings` to 0, or by setting any of `g:yankwin_default_paste_mappings`, `g:yankwin_default_yank_mappings`, or `g:yankwin_default_delete_mappings` to 0.

For example, if you only care about the yank mappings (which, I find, can be quite useful on their own), you can put this in your .vimrc:

``` vim
let g:yankwin_default_yank_mappings   = 1 " optional
let g:yankwin_default_paste_mappings  = 0
let g:yankwin_default_delete_mappings = 0
```

Check the full documentation for these settings to learn how to define your own, any way you like. If you have a proposal for a better set of window mappings that don't override existing ones (or override ones that are not as useful), feel free to open an issue at https://github.com/AndrewRadev/yankwin.vim/issues.

### Yanking and deleting

The only difference between deleting and yanking is whether the window is closed after it's yanked. If you're currently on the fifth line in the file "foo/bar.txt" in your home directory, "/home/me", then the provided mappings would yank the following into the unnamed register:

- `<c-w>y`:  `foo/bar.txt`
- `<c-w>gy`: `/home/me/foo/bar.txt`
- `<c-w>Y`:  `foo/bar.txt:5`
- `<c-w>gY`: `/home/me/foo/bar.txt:5`

Basically, a lowercase "y" copies the (relative) path, and an uppercase "Y" copies a path with its file number at the end (this was made to be consistent with `gf` and `gF`). Prefixing with "g" yanks an absolute path instead of a relative one.

In order to disable the built-in yank mappings and use your own, see the documentation for `g:yankwin_default_yank_mappings`.

Deleting has a similar set of mappings with "d" instead of "y":

- `<c-w>d`:  `foo/bar.txt`
- `<c-w>gd`: `/home/me/foo/bar.txt`
- `<c-w>D`:  `foo/bar.txt:5`
- `<c-w>gD`: `/home/me/foo/bar.txt:5`

In order to disable the built-in delete mappings and use your own, see the documentation for `g:yankwin_default_yank_mappings`.

### Pasting

The mappings to paste a file path are slightly different than the yanking/deleting ones, since there's a lot of options where to put the window -- in a split, in a new tab, or in the current buffer. Here's the built-in ones:

- `<c-w><c-p>`: Pastes in the current window (replaces the window)
- `<c-w>p`:     Pastes in a horizontal split below
- `<c-w>P`:     Pastes in a horizontal split above
- `<c-w>gp`:    Pastes in a new tab page, after the current one
- `<c-w>gP`:    Pastes in a new tab page, before the current one

Note that there are some conflicts with potentially interesting mappings. You might want to read the documentation for `g:yankwin_default_paste_mappings` to learn how to disable these and define your own. You can even define new ones that are not built-in, like ones that open windows in vertical splits.

### Registers

All mappings respect the provided register. For example, typing `"a<c-w>y` will yank the current filename to the "a" register. The `clipboard` setting should also be fully respected, so yanking and pasting files from and to the clipboard should work just fine.

If you'd like to yank to *both* clipboards by default, you could set the `clipboard` setting to "unnamed,unnamedplus", but that forces you to always paste from "+", which can be inconvenient. You can override the setting for "clipboard" on yank by using the `g:yankwin_yank_clipboard` setting:

``` vim
" yank to both clipboards:
let g:yankwin_yank_clipboard = 'unnamed,unnamedplus'

" but paste from "*"
set clipboard=unnamed
```

### Paste processors

One of the reasons this plugin was created was to enable pasting file paths in different formats, potentially from outside sources into Vim. The plugin provides two settings, `g:yankwin_paste_processors` and `g:yankwin_custom_paste_processors`, that contain a set of definitions for some pre-paste processing of any file paths that are pasted.

By default, pasting a file path that looks like `<filename>:<line>:<column>` will not only open that file, but also jump to the provided line and column. This can be useful when copying a file path from test output, for instance.

Also by default, pasting a github url (something that looks like `http://github.com/blob/<path>#L<line>`) will extract the file path and open it in the given line (if there is one).

If you have ideas for additional processors that might be interesting, you can make them yourself using `g:yankwin_custom_paste_processors`, and/or you could open a github issue with your proposal.

## Why?

A lot of the use cases for this plugin can be replicated with built-ins. For instance, if you wanted to "delete" a window from a split and "paste" it in a new tab, you could do that with `<c-w>T`, which is even shorter than the using the plugin mappings. If you wanted to swap two windows by "deleting" the first one and then "pasting" it after the second one, you could just do it with `<c-w>x`

So why use this plugin instead? Here's a few reasons:

1. A consistent interface. The default set of mappings is internally consistent and easy to remember and apply. It's similar to the existing workflow of deleting/yanking/pasting text, which might make it nicer to work with than remembering a different mapping for every use case.

2. Yanking file paths. To my knowledge, there's no built-in mapping to yank a file path to the clipboard, short of running something like `:let @+ = expand('%:p')`, which is quite verbose. The plugin provides various ways to yank file paths for usage with external programs (like, say, running tests on this particular test file, for this particular line).

3. Paste processors. For instance, if you copy a file's github url, you can easily open it locally with `<c-w><c-p>`.

To generalize on point 2, some of the mappings provided just don't have easy analogs within the built-ins. Moving a window from a split to a separate tab is easy with `<c-w>T`, as pointed out above, but the opposite is not that easy, because there's no simple way to specify where the split should go. In this case, "deleting" the tab page leaves you one "paste" mapping away from putting it wherever you like.

The plugin is not complicated, however. If you take a look at the settings, you'll find a full list of the mappings, which simply call a set of autoloaded functions with (hopefully) easy-to-read parameter names. You can disable all mappings and just use these functions in your own commands or mappings.

## Contributing

Pull requests are welcome, but take a look at [CONTRIBUTING.md](https://github.com/AndrewRadev/yankwin.vim/blob/master/CONTRIBUTING.md) first for some guidelines.
