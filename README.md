# gitlineage.nvim

View git history for selected lines in Neovim.

Select a range of lines in visual mode and see how they evolved through git commits using `git log -L`.

## Requirements

**Required:**

- Neovim >= 0.7.0
- Git

**Optional:**

- [diffview.nvim](https://github.com/sindrets/diffview.nvim) - for viewing full commit diffs

## Installation

### lazy.nvim

```lua
{
    "rmj/gitlineage.nvim",
    dependencies = {
        "sindrets/diffview.nvim", -- optional, for open_diff feature
    },
    config = function()
        require("gitlineage").setup()
    end
}
```

### mini.deps / vim.pack.add() (Neovim >= 0.12)

Using mini.deps:

```lua
local add = require("mini.deps").add

add("rmj/gitlineage.nvim")
add("sindrets/diffview.nvim") -- optional, for open_diff feature

require("gitlineage").setup()
```

Using native vim.pack.add():

```lua
vim.pack.add("rmj/gitlineage.nvim")
vim.pack.add("sindrets/diffview.nvim") -- optional, for open_diff feature

require("gitlineage").setup()
```

### vim-plug

```vim
call plug#begin()

Plug 'rmj/gitlineage.nvim'
Plug 'sindrets/diffview.nvim' " optional, for open_diff feature

call plug#end()

lua require("gitlineage").setup()
```

## Configuration

```lua
require("gitlineage").setup({
    split = "auto",       -- "vertical", "horizontal", or "auto"
    keymap = "<leader>gl", -- set to nil to disable default keymap
    keys = {
        close = "q",       -- set to nil to disable
        next_commit = "]c", -- set to nil to disable
        prev_commit = "[c", -- set to nil to disable
        yank_commit = "yc", -- set to nil to disable
        open_diff = "<CR>", -- set to nil to disable (requires diffview.nvim)
    },
})
```

| Option             | Default        | Description                                                                                    |
| ------------------ | -------------- | ---------------------------------------------------------------------------------------------- |
| `split`            | `"auto"`       | How to open the history buffer. `"auto"` picks vertical for wide windows, horizontal for tall. |
| `keymap`           | `"<leader>gl"` | Visual mode keymap. Set to `nil` to define your own.                                           |
| `keys.close`       | `"q"`          | Close the history buffer.                                                                      |
| `keys.next_commit` | `"]c"`         | Jump to next commit.                                                                           |
| `keys.prev_commit` | `"[c"`         | Jump to previous commit.                                                                       |
| `keys.yank_commit` | `"yc"`         | Yank commit SHA when on a commit line.                                                         |
| `keys.open_diff`   | `"<CR>"`       | Open full commit diff (requires diffview.nvim).                                                |

### Custom keymaps

```lua
require("gitlineage").setup({
    keymap = "<leader>gh",
    keys = {
        close = "<Esc>",
        next_commit = "<C-n>",
        prev_commit = "<C-p>",
    },
})
```

## Usage

1. Enter visual mode (`v`, `V`, or `<C-v>`)
2. Select the lines you want to inspect
3. Press `<leader>gl` (or your configured keymap)
4. A split window opens with the git history
5. Navigate using buffer keymaps:

| Key    | Action                                         |
| ------ | ---------------------------------------------- |
| `q`    | Close the history buffer                       |
| `]c`   | Jump to next commit                            |
| `[c`   | Jump to previous commit                        |
| `yc`   | Yank commit SHA (on commit line)               |
| `<CR>` | Open full commit diff (requires diffview.nvim) |

## Testing locally

### From your Neovim config (lazy.nvim)

Point to your local directory:

```lua
{
    "gitlineage.nvim",
    dir = "~/Projects/github/git-history.nvim",
    config = function()
        require("gitlineage").setup()
    end
}
```

### From the project folder

Add to your `init.lua` temporarily:

```lua
vim.opt.runtimepath:prepend("~/Projects/github/git-history.nvim")
require("gitlineage").setup()
```

Or start Neovim with:

```sh
nvim --cmd "set rtp+=~/Projects/github/git-history.nvim" -c "lua require('gitlineage').setup()"
```

### Quick test

1. Open a file tracked by git
2. Select some lines in visual mode
3. Run `:lua require('gitlineage').show_history()`

## Health check

Verify your setup:

```vim
:checkhealth gitlineage
```

This checks:

- Neovim version
- Git availability
- Git repository status
- diffview.nvim availability (optional)
- Plugin configuration

## Documentation

```
:h gitlineage
```

## License

MIT
