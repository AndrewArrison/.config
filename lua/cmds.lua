vim.api.nvim_create_autocmd("BufNewFile", {
	pattern = { "*.cpp", "*.hpp" },
	callback = function()
		local filename = vim.fn.expand("%:t")
        local datetime = os.date("%Y-%m-%d %H:%M:%S")
	    local lines = {
	        "// ================================================",
	        "// File: " .. filename,
		    "// Created on: " .. datetime,
	        "// Last modified: " .. datetime,
            "// Created by: Alwin R Ajeesh",
            "// ================================================",
	        "",
	        }
	    vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)
	    vim.cmd("normal! G")
	end,
})

vim.api.nvim_create_autocmd("BufWritePre", {
	pattern = { "*.cpp", "*.hpp" },
	callback = function()
		local datetime = os.date("%Y-%m-%d %H:%M:%S")
        local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
        for i, line in ipairs(lines) do
			if line:match("^// Last modified:") then
				lines[i] = "// Last modified: " .. datetime
				vim.api.nvim_buf_set_lines(0, i - 1, i, false, { lines[i] })
			break
			end
        end
    end,
})

