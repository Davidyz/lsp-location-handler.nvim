# nvim-location-handler
>A plugin to enhance\* the built-in nvim "jump-to" implementation

The built-in jump to definition etc. works well for jumping. The one thing that has 
been bothering me since I switched from 
[`coc.nvim`](https://github.com/neoclide/coc.nvim) to the built-in lsp is that the 
`jump-to` features open the definition in the same tab. I wrote this plugin, which 
is essentially a decorator to the original 
[location handler](https://github.com/neovim/neovim/blob/6dfabd0145c712e1419dcd6d5ce9192d766adbe3/runtime/lua/vim/lsp/handlers.lua#L362), 
to enable this feature. Since this is just a decorator, this plugin should be 
pretty robust to any upcoming changes in the original implementation of the 
[location handler](https://github.com/neovim/neovim/blob/6dfabd0145c712e1419dcd6d5ce9192d766adbe3/runtime/lua/vim/lsp/handlers.lua#L362).

## Installation
Use your favourite plugin manager.

## Configuration

### Compulsory
Put this lua code
```lua
require('location-handler').setup()
```
in your nvim config.

### Optional

This plugin has 4 configurable options: `open_cmd`, `force_new`, `binded_handlers` and `handler`.

-   `open_cmd` (`string`): is the command that will be passed to a `vim.api.nvim_command` call to
open the new tab/split/etc. to accommodate the original file. The default value is `tabnew`;
-   `force_new` (`boolean`): if false, when the jump target is in the opened file in the current 
buffer, a new tab/split/etc. will *NOT* be opened; if true, a new tab/split/etc. will be created 
even if the target is in the same file. The default value is `false`;
-   `binded_handlers` (`table`): this should be a list of strings. It contains the list of lsp 
methods, such as `textDocument/definition` and `textDocument/declaration`, that the decorated method 
will be binded to. See `./lua/location-handler.lua` for the default value.
-   `handler` (`function`): the decorator function that modify the behaviour of the built-in 
handler. It should accept a function as an argument and return a function with 4 parameters. See 
the source code for the detailed implementation if you wish to modify this.

To modify any of these values, add the updated values in the table that is passed to the `setup` 
function.

* example of using a `vsplit` instead of a new tab for the definition:
```lua
require('location-handler').setup({open_cmd = 'vsplit'})
```
