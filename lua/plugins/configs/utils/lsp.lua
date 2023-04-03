local M = {}

M.in_table = function(element, table)
  for _, value in pairs(table) do
    if value == element then
      return true
    end
  end
  return false
end

-- function that getsthe main file of a latex project
-- hierarchy is as follows:
-- 1. main.tex
-- 3. master.tex
-- 2. main.tex in root
-- 4. master.tex in root
-- 5. first tex file in root that contains \documentclass
-- file output is relative to root_dir
local function get_main_file()
  local root_dir = vim.loop.cwd()
  local main_files = { "main.tex", "master.tex" }
  local main_file = nil

  for _, file in ipairs(main_files) do
    local path = root_dir .. "/" .. file
    if vim.fn.filereadable(path) == 1 then
      main_file = file
      return main_file
    end
  end

  if main_file == nil then
    local files = vim.fn.globpath(root_dir, "*.tex", 0, 1)
    for _, file in ipairs(files) do
      local path = root_dir .. "/" .. file
      local content = io.open(path, "r"):read "*a"
      if content:find "\\documentclass" then
        main_file = file
        return main_file
      end
    end
  end

  if main_file == nil then
    return nil
  end

  return main_file
end

return M
