local M = {}

local ts = require "vim.treesitter"
local query = require "vim.treesitter.query"

local MATH_NODES = {
  displayed_equation = true,
  inline_formula = true,
  math_environment = true,
}

table.unpack = table.unpack or unpack

local function get_node_at_cursor()
  local buf = vim.api.nvim_get_current_buf()
  local row, col = table.unpack(vim.api.nvim_win_get_cursor(0))
  row = row - 1
  col = col - 1

  local parser = ts.get_parser(buf, "latex")
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
    if node:type() == "text_mode" then
      if false then
        -- For \text{}
        local parent = node:parent()
        if parent and MATH_NODES[parent:type()] then
          return false
        end
      end

      return true and not in_comments()
    elseif MATH_NODES[node:type()] then
      return false
    end
    node = node:parent()
  end
  return true and not in_comments()
end

function M.in_mathzone()
  local node = get_node_at_cursor()
  if M.in_label() then
    return false
  end
  if M.in_command "SI" or M.in_command "si" or M.in_command "SIrange" then
    return false
  end
  while node do
    if node:type() == "text_mode" then
      return false
    elseif MATH_NODES[node:type()] then
      return true
    end
    node = node:parent()
  end
  return false
end

function M.in_comment()
  local node = get_node_at_cursor()
  while node do
    if node:type() == "comment" then
      return true
    end
    node = node:parent()
    return false
  end
end

function M.in_label()
  local node = get_node_at_cursor()
  while node do
    if node:type() == "label_definition" then
      return true
    end
    node = node:parent()
  end
  return false
end

function M.in_env(env)
  local LIST = {
    ["{" .. env .. "}"] = true,
    ["{" .. env .. "*}"] = true,
  }
  local buf = vim.api.nvim_get_current_buf()
  local node = get_node_at_cursor()
  while node do
    if node:type() == "generic_environment" then
      local begin = node:child(0)
      local names = begin and begin:field "name"

      if names and names[1] and LIST[vim.treesitter.get_node_text(names[1], buf)] then
        return true
      end
    end
    node = node:parent()
  end
  return false
end

-- ts example:
-- generic_environment [70, 6] - [76, 16]
--   begin: begin [70, 6] - [74, 9]
--     name: curly_group_text [70, 12] - [70, 18]
--       text: text [70, 13] - [70, 17]
--         word: word [70, 13] - [70, 17]
--     options: brack_group [70, 18] - [74, 9]
--       text [71, 10] - [71, 16]
--         word: word [71, 10] - [71, 16]
function M.in_options(env)
  local in_env = M.in_env(env)
  if not in_env then
    return false
  end
  local buf = vim.api.nvim_get_current_buf()
  local node = get_node_at_cursor()
  while node do
    if node:type() == "generic_environment" then
      local begin = node:child(0)
      local options = begin and begin:field "options"
      if options then
        local text = options[1]
        if text then
          local word = text:child(0)
          if word then
            local word_text = vim.treesitter.get_node_text(word, buf)
            if word_text == "[" then
              return true
            end
          end
        end
      end
    end
    node = node:parent()
  end
end

function M.in_command(command)
  local buf = vim.api.nvim_get_current_buf()
  local node = get_node_at_cursor()
  while node do
    if node:type() == "generic_command" then
      local names = node:child(0)
      if names and vim.treesitter.get_node_text(names, buf) == "\\" .. command then
        return true
      end
    end
    node = node:parent()
  end
  return false
end

function M.in_brackets()
  local line = vim.api.nvim_get_current_line()
  local col = vim.fn.col "."
  local left = line:sub(1, col):find "%["
  local right = line:sub(col):find "%]"
  return left and right
end

-- NOTE: if these didnt exist it would be too verbose:
-- condition = function() return M.in_command "SI" end
-- With this, we can do:
-- condition = M.in_SI
function M.in_SI()
  return M.in_command "SI"
end

function M.in_si()
  return M.in_command "si" or M.in_command "SIrange"
end

function M.in_circuitikz()
  return M.in_env "circuitikz"
end

function M.in_axis()
  return M.in_env "axis"
end

function M.in_circuitikz_node()
  return M.in_circuitikz() and M.in_brackets() and not M.in_mathzone()
end

function M.in_table()
  return M.in_env "tabular" or M.in_env "longtable"
end

return M
