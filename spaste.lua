function stripLeadingWhitespace(s)
    return s:gsub("\n%s*", "\n"):gsub("^%s+", "")
end

local args = {...}

if #args ~= 2 then
    print("Usage: spaste [pastebin code] [directory]")
    return
end

local pastebin_code = args[1]
local output_directory = args[2]

local tempfile = "temp_pasting_data.lua"

-- Fetch data from Pastebin
local success = shell.run("pastebin", "get", pastebin_code, tempfile)
if not success then
    print("Failed to fetch data from Pastebin.")
    return
end

-- Load and process data from the fetched file
dofile(tempfile)

-- Remove the fetched file
shell.run("rm", tempfile)

-- Process data
for _, fileData in pairs(data) do
    for filename, contents in pairs(fileData) do
        local outputPath = output_directory .. "/" .. filename
        local outputFile = io.open(outputPath, "w")

        print("Writing to file:", outputPath)

        for _, contentTable in ipairs(contents) do
            for _, line in ipairs(contentTable) do
                outputFile:write(stripLeadingWhitespace(line), "\n")
            end
        end

        outputFile:close()
    end
end
