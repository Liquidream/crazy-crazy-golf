
local ui = castle.ui


-- All the UI-related code is just in this function. Everything below it is normal game code!

function castle.uiupdate()

    --ui.markdown('![](assets/title-text.png)')   

    ui.markdown([[
## CrAzY CrAzY Golf
The craziest crazy golf! 🤪
]])


if ui.button('Save Course') then
    -- TODO: save course to Castle storage
    saveCourse()
end

if DEBUG_MODE then
    if ui.button('Export Course') then
        -- TODO: export course to local storage (disk)
        exportCourse()
    end
    if ui.button('Import Course') then
        -- TODO: export course to local storage (disk)
        importCourse()
    end
end

if ui.button('Share Course') then
    -- TODO: share course to via Castle post
    --shareCourse()
end

if ui.button('Load Course') then
    -- TODO: load course to Castle storage
    loadCourse()
end

if ui.button('Reset Course') then
    -- TODO: reset current course data
    resetCourse()
end

-- if ui.button('Copy Course') then
--     -- TODO: save course to Castle storage
--     copyCourse()
-- end

-- ui.section("Controls", function()

--     ui.markdown([[
-- ### Player Controls
-- **⬆⬇⬅➡** = *Turn*

-- **\[SPACE\]** = *Boost!*

-- ### Advanced controls
-- **S** = *Toggle GFX Shader*
-- ]])

-- end)


--     ui.markdown([[
-- #### Other Settings
-- ]])

--     ui.section("Shader settings", function()

--         ui.toggle("Shader OFF", "Shader ON", useShader,
--         { onToggle = function()
--             useShader = not useShader
--             shader_switch(useShader)
--         end }
--         )

--         local refresh = false
--         shader_crt_curve      = ui.slider("CRT Curve",      shader_crt_curve,      0, 0.25, { step = 0.0025, onChange = function() refresh = true end })
--         shader_glow_strength  = ui.slider("Glow Strength",  shader_glow_strength,  0, 1,    { step = 0.01, onChange = function() refresh = true end })
--         shader_distortion_ray = ui.slider("Distortion Ray", shader_distortion_ray, 0, 10,   { step = 0.1, onChange = function() refresh = true end })
--         shader_scan_lines     = ui.slider("Scan Lines",     shader_scan_lines,     0, 1.0,  { step = 0.01, onChange = function() refresh = true end })
--         if refresh then update_shader_parameters() end

--     end)



end
