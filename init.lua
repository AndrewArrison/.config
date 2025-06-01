-- Set leader key
vim.g.mapleader = " "

-- Setup Lazy.nvim
vim.cmd([[packadd lazy.nvim]])

--colorscheme
vim.cmd.colorscheme("retrobox")

local lazypath = vim.fn.stdpath("data") .. "/site/pack/lazy/start/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
-- vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	"nvim-treesitter/nvim-treesitter",
  	"nvim-lua/plenary.nvim",
  	"nvim-telescope/telescope.nvim", tag = '0.1.8',
  	"nvim-lualine/lualine.nvim", dependencies = { 'nvim-tree/nvim-web-devicons' },
  	"goolord/alpha-nvim",
	"windwp/nvim-autopairs",
	"neovim/nvim-lspconfig",
	"hrsh7th/nvim-cmp",
	"hrsh7th/cmp-nvim-lsp",
	"L3MoN4D3/LuaSnip",
	"saadparwaiz1/cmp_luasnip",
})

vim.o.updatetime = 250
vim.cmd[[autocmd CursorHold * lua vim.diagnostic.open_float(nil, {focus=false})]]
require('keymap')
require('cmds')
-- General indentation settings
vim.opt.smartindent = true
vim.opt.autoindent = true
vim.opt.tabstop = 4        -- Number of spaces for a <Tab>
vim.opt.shiftwidth = 4     -- Indent size
vim.opt.expandtab = false  -- Use actual tabs (like VS Code for C++)
vim.opt.nu = true
vim.opt.relativenumber = true
vim.opt.signcolumn = "yes"
vim.opt.colorcolumn = "80"
vim.api.nvim_set_hl(0, "colorColumn", { bg = "#800000"})
vim.opt.scrolloff = 8
--treesitter
require'nvim-treesitter.configs'.setup {
  -- A list of parser names, or "all" (the listed parsers MUST always be installed)
  ensure_installed = { "c", "lua", "cpp"},
  highlight = {
    enable = true,
    -- disable = { "c", "rust" },
	},
	indent = { enable = true; },
}

--telescope
require("telescope").setup({
	defaults = {
		prompt_prefix = " ",
		--selection_caret = " ",
		-- path_display = { "smart" },
		
		layout_strategy = "horizontal",
		layout_config = { preview_width = 0.6, },

		mappings = {
			i = {
				["<C-p>"] = require('telescope.actions.layout').toggle_preview,
				["<C-h>"] = require('telescope.actions').preview_scrolling_up,
				["<C-j>"] = require('telescope.actions').preview_scrolling_down,
				["<C-c>"] = require('telescope.actions').close
			}
		}
	}
})

--lualine
require('lualine').setup {
  options = {
    icons_enabled = true,
    theme = 'auto',
    component_separators = { left = '', right = ''},
    section_separators = { left = '', right = ''},
    always_divide_middle = true,
    always_show_tabline = true,
    globalstatus = false,
    refresh = {
      statusline = 1000,
      tabline = 1000,
      winbar = 1000,
    }
  },
  sections = {
    lualine_a = {'mode'},
    lualine_b = {'diagnostics'},
    lualine_c = {'filename'},
    lualine_x = {'filetype', 'lsp_status'},
    lualine_y = {'progress'},
    lualine_z = {'location'}
  },
  inactive_sections = {
    lualine_c = {'filename'},
    lualine_x = {'location'},
  },
}


--alpha
require('alpha').setup(require'alpha.themes.dashboard'.config)

--autopairs
require('nvim-autopairs').setup {}

require('lspconfig').clangd.setup({
	capabilities = require("cmp_nvim_lsp").default_capabilities(),
})


local cmp = require("cmp")
local luasnip = require("luasnip")
cmp.setup({
	--   performance = {
	-- 	debounce = 10,
	-- 	throttle = 20,
	-- 	fetching_timeout = 50,
	-- },
	window = {
		completion = cmp.config.window.bordered({
			max_height = 10,
		}),
		documentation = cmp.config.window.bordered(),
	},
	experimental = {
		ghost_text = true,
	},
	formatting = {
		format = function(entry, vim_item)
			vim_item.menu = nil
			vim_item.abbr = vim_item.abbr:sub(1, 30 - 3) .. "…"
	      return vim_item
	    end,
		  },
	  snippet = {
		    expand = function(args)
			      luasnip.lsp_expand(args.body)
		    end,
		  },
	  mapping = cmp.mapping.preset.insert({
		    ['<C-Space>'] = cmp.mapping.complete(),
		    ['<CR>'] = cmp.mapping.confirm({ select = true }),
		    ['<Tab>'] = cmp.mapping(function(fallback)
		      if cmp.visible() then
		        cmp.select_next_item()
	      elseif luasnip.expand_or_jumpable() then
	        luasnip.expand_or_jump()
	      else
	        fallback()
	      end
	    end, { "i", "s" }),
		    ['<S-Tab>'] = cmp.mapping(function(fallback)
		      if cmp.visible() then
		        cmp.select_prev_item()
	      elseif luasnip.jumpable(-1) then
	        luasnip.jump(-1)
	      else
	        fallback()
	      end
	    end, { "i", "s" }),
		  }),
	  sources = cmp.config.sources({
		    { name = 'nvim_lsp' },
		    { name = 'luasnip' },
		  })
})
