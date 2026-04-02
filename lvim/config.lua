-- Detect remote SSH sessions (HPC or otherwise)
local is_ssh = (os.getenv("SSH_CONNECTION") or os.getenv("SSH_TTY") or os.getenv("REMOTEHOST")) ~= nil

-- Optionally also detect tmux + SSH (for login nodes where tmux is spawned right after SSH)
if not is_ssh then
  local parent = os.getenv("TMUX")
  if parent and #parent > 0 then
    -- Might be inside tmux on a remote machine
    -- Heuristic: check if SSH_CLIENT or SSH_CONNECTION existed before tmux was started
    is_ssh = os.getenv("SSH_CLIENT") ~= nil
  end
end

-- Apply lighter settings when remote
if is_ssh then
  lvim.builtin.alpha.active = false
  lvim.builtin.bufferline.active = false
  vim.opt.termguicolors = false
  -- optionally disable icons for speed
  require("nvim-web-devicons").setup { default = true, override = {} }
end

-- LSP servers to install (basedpyright preferred over pyright to avoid Node on HPC)
lvim.lsp.installer.setup.ensure_installed = { "clangd", "basedpyright", "lua_ls" }
lvim.format_on_save = { enabled = true }

-- Prefer GCC/Clang compilers for parser builds (avoid NVHPC `nvc`)
pcall(function()
  local ts_install = require("nvim-treesitter.install")
  ts_install.compilers = { "gcc", "clang", "cc" }   -- order matters
  -- Optional for clusters with flaky git:
  -- ts_install.prefer_git = false
end)

