![logo](https://raw.githubusercontent.com/LionyxML/gitlineage.nvim/refs/heads/media/logo.png)

# gitlineage.nvim

View git history for selected lines in Neovim.

Select a range of lines in visual mode, use the `:GitLineage` command, or
press the keymap in normal mode to see how they evolved through git commits
using `git log -L`.

## How it Works

1. Select a range of lines in visual mode, or just place your cursor on a line.

   ![demo_1](https://raw.githubusercontent.com/LionyxML/gitlineage.nvim/refs/heads/media/demo_1.png)

2. Press `<leader>gl` (all bindings are customizable, see the Installation
   section below), or run `:GitLineage`. A new split window opens with the git
   history of the selected lines (or current line if no selection).

   ![demo_2](https://raw.githubusercontent.com/LionyxML/gitlineage.nvim/refs/heads/media/demo_2.png)

3. Advance through commits with `]c`.

   ![demo_3](https://raw.githubusercontent.com/LionyxML/gitlineage.nvim/refs/heads/media/demo_3.png)

4. Quickly yank the commit SHA with `yc`.

   ![demo_4](https://raw.githubusercontent.com/LionyxML/gitlineage.nvim/refs/heads/media/demo_4.png)

5. Go back to previous commits with `[c`.

   ![demo_5](https://raw.githubusercontent.com/LionyxML/gitlineage.nvim/refs/heads/media/demo_5.png)

6. If `diffview.nvim` is installed, open the full commit diff by hitting `<CR>` on a commit line.

   ![demo_6](https://raw.githubusercontent.com/LionyxML/gitlineage.nvim/refs/heads/media/demo_6.png)

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
    "lionyxml/gitlineage.nvim",
    dependencies = {
        "sindrets/diffview.nvim", -- optional, for open_diff feature
    },
    config = function()
        require("gitlineage").setup()
    end
}
```

### mini.deps

Using mini.deps:

```lua
local add = require("mini.deps").add

add("sindrets/diffview.nvim") -- optional, for open_diff feature
add("lionyxml/gitlineage.nvim")

require("gitlineage").setup()
```

### vim.pack.add() (Neovim >= 0.12)

Using native vim.pack.add():

```lua
vim.pack.add({
	"https://github.com/sindrets/diffview.nvim", -- optional, for open_diff feature
	"https://github.com/lionyxml/gitlineage.nvim",
})

require("gitlineage").setup()
```

### vim-plug

```vim
call plug#begin()

Plug 'sindrets/diffview.nvim' " optional, for open_diff feature
Plug 'lionyxml/gitlineage.nvim'

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

| Option             | Default      | Description                                                                                  |
| ------------------ | ------------ | -------------------------------------------------------------------------------------------- |
| `split`            | `auto`       | How to open the history buffer. `auto` picks vertical for wide windows, horizontal for tall. |
| `keymap`           | `<leader>gl` | Normal and visual mode keymap. Set to `nil` to define your own.                              |
| `keys.close`       | `q`          | Close the history buffer.                                                                    |
| `keys.next_commit` | `]c`         | Jump to next commit.                                                                         |
| `keys.prev_commit` | `[c`         | Jump to previous commit.                                                                     |
| `keys.yank_commit` | `yc`         | Yank commit SHA when on a commit line.                                                       |
| `keys.open_diff`   | `<CR>`       | Open full commit diff (requires diffview.nvim).                                              |

### Custom keymaps

```lua
require("gitlineage").setup({
    keymap = "<leader>gh",
    keys = {
        close = "<Esc>",
        next_commit = "<C-n>",
        prev_commit = "<C-p>",
        yank_commit = "y",
        open_diff = "d",
    },
})
```

## Usage

### Using the keymap

1. In **normal mode**, press `<leader>gl` to show history for the current line
2. In **visual mode**, select lines and press `<leader>gl` to show history for the selection

### Using the command

- `:GitLineage` — show history for the current line
- `:'<,'>GitLineage` — show history for the visual selection (just type `:GitLineage` while in visual mode)
- `:10,20GitLineage` — show history for an explicit line range

### Buffer keymaps

Once the history buffer is open, navigate using:

| Key    | Action                                         |
| ------ | ---------------------------------------------- |
| `q`    | Close the history buffer                       |
| `]c`   | Jump to next commit                            |
| `[c`   | Jump to previous commit                        |
| `yc`   | Yank commit SHA (on commit line)               |
| `<CR>` | Open full commit diff (requires diffview.nvim) |

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

## Similar Plugins

- [mini-git](https://github.com/nvim-mini/mini.nvim/blob/main/readmes/mini-git.md) - `MiniGit.show_range_history()`
- [diffview.nvim](https://github.com/sindrets/diffview.nvim) - `:DiffviewFileHistory`
