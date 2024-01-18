-- if vim.g.loaded_grammarous == 1 then
--     return
-- end
vim.g.loaded_grammarous = 1

-- Create an options parser for auto completion
local OptionParser = {}

function OptionParser.new()
    local self = {
        options = {}
    }

    function self:add_option(option)
        table.insert(self.options, option)
    end

    -- Gets completion suggestions
    function self:complete(arglead)
        local matches = {}
        for _, option in pairs(self.options) do
            if option:find(arglead) == 1 then
                table.insert(matches, option)
            end
        end
        return matches
    end

    return self
end

local opt_parser = OptionParser.new()
opt_parser:add_option('--lang=')
opt_parser:add_option('--preview')
opt_parser:add_option('--no-preview')
opt_parser:add_option('--comments-only')
opt_parser:add_option('--no-comments-only')
opt_parser:add_option('--move-to-first-error')
opt_parser:add_option('--no-move-to-first-error')
opt_parser:add_option('--reinstall-languagetool')


local function grammarous_complete_opt(arglead)
    local completion_options = opt_parser:complete(arglead)

    return completion_options
end

-- Create user commands
vim.api.nvim_create_user_command("GrammarousCheck1",
    function(opts)
        local args = vim.split(opts.args, "%s+")
        require("grammarous.checker").check_current_buffer(args, { opts.line1, opts.line2 })
    end,
    {
        nargs = "*",
        range = "%",
        complete = function(_, line)
            local n = vim.split(line, "%s+")
            return grammarous_complete_opt(n[#n])
        end,
    }
)

vim.api.nvim_create_user_command("GrammarousReset1",
    function()
        require("grammarous.checker").reset()
    end,
    {
        nargs = 0,
    }
)

-- nnoremap <silent><Plug>(grammarous-move-to-info-window) :<C-u>call grammarous#create_and_jump_to_info_window_of(b:grammarous_result)<CR>
-- nnoremap <silent><Plug>(grammarous-open-info-window) :<C-u>call grammarous#create_update_info_window_of(b:grammarous_result)<CR>
-- nnoremap <silent><Plug>(grammarous-reset) :<C-u>call grammarous#reset()<CR>
-- nnoremap <silent><Plug>(grammarous-fixit) :<C-u>call grammarous#fixit(grammarous#get_error_at(getpos('.')[1 : 2], b:grammarous_result))<CR>
-- nnoremap <silent><Plug>(grammarous-fixall) :<C-u>call grammarous#fixall(b:grammarous_result)<CR>
-- nnoremap <silent><Plug>(grammarous-close-info-window) :<C-u>call grammarous#info_win#close()<CR>
-- nnoremap <silent><Plug>(grammarous-remove-error) :<C-u>call grammarous#remove_error_at(getpos('.')[1 : 2], b:grammarous_result)<CR>
-- nnoremap <silent><Plug>(grammarous-disable-rule) :<C-u>call grammarous#disable_rule_at(getpos('.')[1 : 2], b:grammarous_result)<CR>
-- nnoremap <silent><Plug>(grammarous-disable-category) :<C-u>call grammarous#disable_category_at(getpos('.')[1 : 2], b:grammarous_result)<CR>
-- nnoremap <silent><Plug>(grammarous-move-to-next-error) :<C-u>call grammarous#move_to_next_error(getpos('.')[1 : 2], b:grammarous_result)<CR>
-- nnoremap <silent><Plug>(grammarous-move-to-previous-error) :<C-u>call grammarous#move_to_previous_error(getpos('.')[1 : 2], b:grammarous_result)<CR>
