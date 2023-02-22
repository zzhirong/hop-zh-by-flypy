local jump_target = require'hop.jump_target'
local hop = require'hop'
local flypy_table = require'hop-zh-by-flypy.flypy_table'
local hint = require'hop.hint'

local M = {}

local function map(mode, l, f, opts)
    vim.keymap.set(mode, l,
        function()
            M[f](opts)
        end,
        { remap = true }
    )
end

local function create_default_mappings()
    local directions = require('hop.hint').HintDirection
    map({'x', 'n', 'o'}, 'f', "hint_char1", {
        direction = directions.AFTER_CURSOR,
        current_line_only = true
    })

    map({'x', 'n', 'o'}, 'F', "hint_char1", {
        direction = directions.BEFORE_CURSOR,
        current_line_only = true
    })

    map({'x', 'n', 'o'}, 't', "hint_char1", {
        direction = directions.AFTER_CURSOR,
        current_line_only = true,
        offset = -1,
    })

    map({'x', 'n', 'o'}, 'T', "hint_char1", {
        direction = directions.AFTER_CURSOR,
        current_line_only = true,
        offset = 1,
    })

    map('n', 's', "hint_char2", {})
end

local function create_commands()
    local command = vim.api.nvim_create_user_command
    command("HopFlypy1", function()
        M.hint_char1()
    end, {})
    command("HopFlypy1BC", function()
        M.hint_char1({ direction = hint.HintDirection.BEFORE_CURSOR })
    end, {})
    command("HopFlypy1AC", function()
        M.hint_char1({ direction = hint.HintDirection.AFTER_CURSOR })
    end, {})
    command("HopFlypy1CurrentLine", function()
        M.hint_char1({ current_line_only = true })
    end, {})
    command("HopFlypy1CurrentLineBC", function()
        M.hint_char1({ direction = hint.HintDirection.BEFORE_CURSOR, current_line_only = true })
    end, {})
    command("HopFlypy1CurrentLineAC", function()
        M.hint_char1({ direction = hint.HintDirection.AFTER_CURSOR, current_line_only = true })
    end, {})
    command("HopFlypy1MW", function()
        M.hint_char1({ multi_windows = true })
    end, {})

    -- The jump-to-char-2 command.
    command("HopFlypy2", function()
        M.hint_char2()
    end, {})
    command("HopFlypy2BC", function()
        M.hint_char2({ direction = hint.HintDirection.BEFORE_CURSOR })
    end, {})
    command("HopFlypy2AC", function()
        M.hint_char2({ direction = hint.HintDirection.AFTER_CURSOR })
    end, {})
    command("HopFlypy2CurrentLine", function()
        M.hint_char2({ current_line_only = true })
    end, {})
    command("HopFlypy2CurrentLineBC", function()
        M.hint_char2({ direction = hint.HintDirection.BEFORE_CURSOR, current_line_only = true })
    end, {})
    command("HopFlypy2CurrentLineAC", function()
        M.hint_char2({ direction = hint.HintDirection.AFTER_CURSOR, current_line_only = true })
    end, {})
    command("HopFlypy2MW", function()
        M.hint_char2({ multi_windows = true })
    end, {})
end

function M.hint_char1(opts)
    opts = setmetatable(opts or {}, {__index = M.opts})

    local ok, c = pcall(vim.fn.getchar)
    if not ok then
        return
    end

    local generator
    if opts.current_line_only then
        generator = jump_target.jump_targets_for_current_line
    else
        generator = jump_target.jump_targets_by_scanning_lines
    end

    local pat = vim.fn.nr2char(c)
    pat = flypy_table.char1[pat] or pat
    hop.hint_with(
        generator(jump_target.regex_by_case_searching(pat, false, opts)),
        opts
    )
end

function M.hint_char2(opts)
    opts = setmetatable(opts or {}, {__index = M.opts})

    local ok, a = pcall(vim.fn.getchar)
    if not ok then
        return
    end

    local ok2, b = pcall(vim.fn.getchar)
    if not ok2 then
        return
    end

    local pattern = vim.fn.nr2char(a)

    -- if we have a fallback key defined in the opts, if the second character is that key, we then fallback to the same
    -- behavior as hint_char1()
    if opts.char2_fallback_key == nil or
        b ~= vim.fn.char2nr(vim.api.nvim_replace_termcodes(opts.char2_fallback_key, true, false, true)) then
        pattern = pattern .. vim.fn.nr2char(b)
    end

    pattern = flypy_table.char2[pattern] or pattern
    local generator
    if opts.current_line_only then
        generator = jump_target.jump_targets_for_current_line
    else
        generator = jump_target.jump_targets_by_scanning_lines
    end

    hop.hint_with(
        generator(jump_target.regex_by_case_searching(pattern, false, opts)),
        opts
    )
end

-- Will be called by hop.nvim
function M.register(opts)
    M.opts = opts
    create_commands()
end

-- Called by lazy.nvim
function M.setup(opts)
    if opts.set_default_mappings then
        create_default_mappings()
    end
end

return M
