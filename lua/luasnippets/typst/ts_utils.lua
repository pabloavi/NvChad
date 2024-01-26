local M = {}

local ts = require "vim.treesitter"
local query = require "vim.treesitter.query"

table.unpack = table.unpack or unpack

local function get_node_at_cursor()
  local buf = vim.api.nvim_get_current_buf()
  local row, col = table.unpack(vim.api.nvim_win_get_cursor(0))
  row = row - 1
  col = col - 1

  local parser = ts.get_parser(buf, "typst")
  if not parser then
    return
  end
  local root_tree = parser:parse()[1]
  local root = root_tree and root_tree:root()

  if not root then
    return
  end

  return root:named_descendant_for_range(row, col, row, col)
end

---Check if cursor is in treesitter capture
---@param capture string
---@return boolean
local function in_ts_capture(capture)
  local buf = vim.api.nvim_get_current_buf()
  local row, col = table.unpack(vim.api.nvim_win_get_cursor(0))
  row = row - 1
  col = col - 1

  local captures = ts.get_captures_at_pos(buf, row, col)

  for _, c in ipairs(captures) do
    if c.capture == capture then
      return true
    end
  end

  return false
end

---Check if cursor is in treesitter capture of 'comment'
---@return boolean
local function in_comments()
  return in_ts_capture "comment"
end

function M.in_text()
  -- check_parent = false
  local node = get_node_at_cursor()
  while node do
    if node:type() == "content" or node:type() == "string" then
      if false then
        -- For \text{}
        local parent = node:parent()
        if parent and parent:type() == "math" then
          return false
        end
      end

      return true and not in_comments()
    elseif node:type() == "math" then
      return false
    end
    node = node:parent()
  end
  return true and not in_comments()
end

function M.in_mathzone()
  local node = get_node_at_cursor()
  while node do
    if node:type() == "content" or node:type() == "string" then
      return false
    elseif node:type() == "math" then
      return true
    end
    node = node:parent()
  end
  return false
end

-- function M.in_env(env)
--   local LIST = {
--     ["{" .. env .. "}"] = true,
--     ["{" .. env .. "*}"] = true,
--   }
--   local buf = vim.api.nvim_get_current_buf()
--   local node = get_node_at_cursor()
--   while node do
--     if node:type() == "generic_environment" then
--       local begin = node:child(0)
--       local names = begin and begin:field "name"
--
--       if names and names[1] and LIST[vim.treesitter.get_node_text(names[1], buf)] then
--         return true
--       end
--     end
--     node = node:parent()
--   end
--   return false
-- end
--
-- -- ts example:
-- -- generic_environment [70, 6] - [76, 16]
-- --   begin: begin [70, 6] - [74, 9]
-- --     name: curly_group_text [70, 12] - [70, 18]
-- --       text: text [70, 13] - [70, 17]
-- --         word: word [70, 13] - [70, 17]
-- --     options: brack_group [70, 18] - [74, 9]
-- --       text [71, 10] - [71, 16]
-- --         word: word [71, 10] - [71, 16]
-- function M.in_options(env)
--   local in_env = M.in_env(env)
--   if not in_env then
--     return false
--   end
--   local buf = vim.api.nvim_get_current_buf()
--   local node = get_node_at_cursor()
--   while node do
--     if node:type() == "generic_environment" then
--       local begin = node:child(0)
--       local options = begin and begin:field "options"
--       if options then
--         local text = options[1]
--         if text then
--           local word = text:child(0)
--           if word then
--             local word_text = vim.treesitter.get_node_text(word, buf)
--             if word_text == "[" then
--               return true
--             end
--           end
--         end
--       end
--     end
--     node = node:parent()
--   end
-- end
--
-- function M.in_command(command)
--   local buf = vim.api.nvim_get_current_buf()
--   local node = get_node_at_cursor()
--   while node do
--     if node:type() == "call" then
--       local names = node:child(0)
--       if names and vim.treesitter.get_node_text(names, buf) == command then
--         return true
--       end
--     end
--     node = node:parent()
--   end
--   return false
-- end

return M
