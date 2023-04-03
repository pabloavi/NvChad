dofile(vim.g.base46_cache .. "nvchad_updater")

local nvim_config = vim.fn.stdpath "config"
local chadrc_config = require("core.utils").load_config()
local config_branch = chadrc_config.options.nvChad.update_branch

local api = vim.api
local uv = vim.loop

-- on new releases the branch has to be changed
-- local local_branch
--
-- local job_id = vim.fn.jobstart({ "git", "branch", "--show-current" }, {
--   cwd = nvim_config,
--   on_stdout = function(_, data)
--     local_branch = data[1]
--   end,
--   stdout_buffered = true,
--   on_exit = function()
--     if config_branch ~= local_branch then
--       vim.fn.system { "git", "-C", nvim_config, "switch", config_branch }
--     end
--   end,
-- })
--
-- vim.fn.jobwait({ job_id }, -1)

-- used to make each line have equal widths
local function add_whiteSpaces(tb, is_error_text)
  -- first get largest line's length
  local len = 0

  for _, value in ipairs(tb) do
    if len < #value then
      len = #value
    end
  end

  table.insert(tb, 1, string.rep(" ", len))

  -- now fill whitespaces
  for i, value in ipairs(tb) do
    local empty_line = string.match(value, "^%s*$")
    local icon_type = is_error_text and "  " or " "
    local icon = empty_line and "    " or "  " .. icon_type
    local whitespaces_len = len - #value
    local str_has_colon = string.find(value, ":")

    -- remove : after commit hash too
    tb[i] = icon
      .. value:gsub(":", "")
      .. string.rep(" ", whitespaces_len + (((str_has_colon and not is_error_text) and 3) or 2))
  end

  -- 4 = 2 spaces on left & right
  tb[#tb + 1] = string.rep(" ", len + 6)

  return tb
end

local spinners = { "", "󰪞", "󰪟", "󰪠", "󰪢", "󰪣", "󰪤", "󰪥" }
-- local spinners = { "󰸶", "󰸸", "󰸷", "󰸴", "󰸵", "󰸳" }
-- local spinners = { "", "", "", "󰺕", "", "" }
local content = { " ", " ", "" }

local header = " 󰓂 Update status "

return function()
  -- create buffer
  local buf = vim.api.nvim_create_buf(false, true)

  vim.cmd "sp"
  vim.api.nvim_set_current_buf(buf)
  vim.opt_local.buflisted = false
  vim.opt_local.number = false
  vim.opt_local.list = false
  vim.opt_local.relativenumber = false
  vim.opt_local.wrap = false
  vim.opt_local.cul = false

  -- set lines & highlight updater title
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, content)
  local nvUpdater = api.nvim_create_namespace "nvUpdater"
  api.nvim_buf_add_highlight(buf, nvUpdater, "nvUpdaterTitle", 1, 0, -1)

  local git_outputs = {} -- some value gets assigned here after 3-4 seconds
  local index = 1

  -- update spinner icon until git_outputs is empty
  -- use a timer
  local timer = vim.loop.new_timer()

  timer:start(0, 100, function()
    index = index + 1

    if #git_outputs ~= 0 then
      timer:stop()
    end

    vim.schedule(function()
      if #git_outputs == 0 then
        -- restart spinner animation
        if index == #spinners then
          index = 1
        end

        content[2] = header .. " " .. spinners[index] .. "  "
        vim.api.nvim_buf_set_lines(buf, 0, -1, false, content)
        api.nvim_buf_add_highlight(buf, nvUpdater, "nvUpdaterTitle", 1, 0, #header)
        api.nvim_buf_add_highlight(buf, nvUpdater, "nvUpdaterProgress", 1, #header, -1)
      end
    end)
  end)

  -----  get git pull output, use vim.loop.spawn
  local handle
  local stdout = uv.new_pipe()
  local stderr = uv.new_pipe()

  local git_fetch_err = false

  local function on_exit()
    uv.read_stop(stdout)
    uv.close(stdout)
    uv.close(handle)

    -- set lines & highlights
    -- using vim.schedule because we cant use set_lines & systemlist in callback
    vim.schedule(function()
      if not git_fetch_err then
        -- git log --format="format:%h: %s"  HEAD..origin/somebranch
        local head_hash = vim.fn.systemlist("git -C " .. nvim_config .. " rev-parse HEAD")

        git_outputs = vim.fn.systemlist(
          "git -C " .. nvim_config .. ' log --format="format:%h: %s" ' .. head_hash[1] .. "..origin/" .. config_branch
        )

        if #git_outputs == 0 then
          git_outputs = { "Already updated!" }
        end
      end

      -- draw the output on buffer
      add_whiteSpaces(git_outputs, git_fetch_err)

      local success_update = " 󰓂 Update status    "
      local failed_update = " 󰓂 Update status  󰚌 "

      content[2] = git_fetch_err and failed_update or success_update

      -- append gitpull table to content table
      for i = 1, #git_outputs, 1 do
        content[#content + 1] = git_outputs[i]
      end

      vim.api.nvim_buf_set_lines(buf, 0, -1, false, content)

      local title_hl = "nvUpdaterTitle" .. (git_fetch_err and "FAIL" or "DONE")
      local progress_hl = "nvUpdaterProgress" .. (git_fetch_err and "FAIL" or "DONE")

      -- highlight title & finish icon
      api.nvim_buf_add_highlight(buf, nvUpdater, title_hl, 1, 0, #header)
      api.nvim_buf_add_highlight(buf, nvUpdater, progress_hl, 1, #header, -1)

      for i = 2, #content do
        api.nvim_buf_add_highlight(buf, nvUpdater, "nvUpdaterGitPull", i, 0, -1)

        if not git_fetch_err then
          api.nvim_buf_add_highlight(buf, nvUpdater, "nvUpdaterCommits", i, 2, 13) -- 7 = length of git commit hash aliases + 1 :
        end
      end

      vim.fn.jobstart({ "git", "pull" }, { silent = true, cwd = nvim_config })
      vim.cmd "Lazy sync"
    end)
  end

  local opts = {
    args = { "fetch" },
    cwd = nvim_config,
    stdio = { nil, stdout, stderr },
  }

  handle = uv.spawn("git", opts, on_exit)

  uv.read_start(stdout, function(_, data)
    if data then
      git_outputs[#git_outputs + 1] = data:gsub("\n", "")
    end
  end)

  uv.read_start(stderr, function(_, data)
    if data then
      git_fetch_err = true
      git_outputs[#git_outputs + 1] = data:gsub("\n", "")
    end
  end)
end
