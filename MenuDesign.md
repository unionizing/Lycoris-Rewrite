# Menu Design Markers
- ✅ - Finished working on it
- ⚠️ - Done or partially done and working on it, needs rewrite, or has edge cases
    - ⚠️⚠️ - Indicates that it is not tested at all
    - ⚠️⚠️⚠️ - Indicates that it is broken but written
- ❌ - Not doing it right now or not done at all

Tabs have a marker to desiginate whether or not the menu elements are finished.

# Ordered Menu Design
- Combat ✅
    - Combat Targeting ✅
        - Player Selection Type ❌
            - Closest In Distance ❌ 
            - Closest To Crosshair ❌
            - Least Health ❌
        - Player Whitelist ❌
            - Username List ❌
            - Username Input Box ❌
            - Add Username To Whitelist ❌
            - Remove Selected Username ❌
        - FOV Limit ❌
        - Ignore Mobs ❌
        - Ignore Friends ❌
        - Must Face Target ❌
    - Auto Defense ✅
        - Enable Auto Defense ❌
        - Auto Defense Confinguration ❌
        - Auto Defense Notifications ❌
        - Auto Defense Visualizations ❌
    - Feint Detection ✅
        - Detect M1 Feints ❌
        - Detect Mantra Feints ❌
        - React To Feints ❌
            - Feint Reaction Chance ❌
    - Attack Assistance ✅
        - Feint M1 While Defending ❌
        - Feint Mantras While Defending ❌
    - Input Assistance ✅
        - Block M1 While Defending ❌
        - Block Critical While Defending ❌
        - Block Mantras While Defending ❌
        - Block Seconds ❌
    - Combat Assistance ✅
        - Silent Aim ❌
        - Allow Flourish Feints ❌
        - Allow Attacks While Rolling ❌
        - Attack Animation Speed ❌
            - Animation Speed Slider (0.5x - 1x - 2x) ❌
        - Maximum Momentum ❌
        - Perfect Mantra Cast ❌

    Use Counter Mantras When Avaliable

    Account for Hyperarmor in Auto Defense

    Hold Block For Auto Defense

- Game ✅
    - Local Character ✅
        - Fly ✅
            - Fly Speed ✅
        - No Clip ✅ 
            - Allow Collisions While Knocked ✅
        - Speedhack ✅
            - Speedhack Speed ✅
        - Infinite Jump ✅
            - Infinite Jump Speed ✅
        - Auto Sprint ✅
        - Agility Spoofer ✅
            - Agility Value ✅
        - Tween To Objective ✅
        - Attach To Back ✅
            - Height Offset ✅
            - Back Offset ✅
        - Freestylers Band Spoofer ✅    --> group these 2 as talent spoofer
        - Konga's Clutch Ring Spoofer ✅ ^
        - Emote Spoofer ✅ 
        - Remove "Loot All" CD ❌
    - Effect Removals ✅
        - No Speed Debuff ✅
        - No Stun ✅
        - No Acid Damage ✅
        - No Fall Damage ✅
        - No Wind ✅
        - No Jump Cooldown ✅
    - Instance Removals ✅
        - Remove Kill Bricks ✅
        - Remove Echo Modifiers ✅
    - Player Monitoring ✅
        - Player List Spectating ✅
        - Player Proximity Notifications ✅
            - Proximity Distance (50m - 350m - 1000m) ✅
            - Only Allow Voidwalkers ✅
        - Void Walker Contract Notifications ✅
        - Legendary Weapon Notifications ✅
        - Mod Notifications ✅
        - Show All Players in Map ❌
        - Chat Spy ❌
    
    Check out "Hide From Heartbeat Sensor"

    Check out "Reveal Mystery Mantras"

    Check out "Hide Shadowcast Visual"

    Check out "Hide HP Bar Block"

    Check out "Hide Void Spire Visual"

    Check out "Remove Castle Light Gate"

- Visuals ✅
    - ESP Customization ✅
        - Text Font Size ✅
        - Text Font Selection ✅
    - ESP Optimizations ✅
        - Object Split Updates ✅
            - Update Frames ✅
        - Object Check Delay ✅
            - Ignore Humanoids ✅
            - Delay Time ✅
    - Interface Visuals ✅
        - Show Roblox Chat ✅
    - World Visuals ✅
        - Modify Field Of View ✅
            - FOV Slider ✅
        - Modify Ambience ✅
            - Use Original Ambience Color ✅
            - Ambience Brightness ✅
    - Visual Removals ✅
        - No Blind ✅
        - No Fog ✅
        - No Blur ✅
        - No Shadows ✅
    - Other ESP Groupboxes ✅
    - Player ESP Groupbox ✅
        - Ally ESP ✅
            - Ally ESP Color ✅
    - Bag ESP Groupbox ✅
    - Ingredient ESP Groupbox ✅
        - Filter Ingredients ✅
            - Filter Ingredients List ✅
            - Filter List Type ✅
                - Hide Other Names ✅
                - Hide Names ✅
            - Filter Ingredient Name ✅
            - Add Ingredient To Filter ✅
            - Remove Selected Ingredient ✅
    - Area Marker ESP Groupbox ✅
        - Filter Area Marker ✅
            - Filter Area Marker List ✅
            - Filter Area Marker Name ✅
            - Filter List Type ✅
                - Hide Other Names ✅
                - Hide Names ✅
            - Add Area Marker To Filter ✅
            - Remove Selected Area Marker ✅

    Remove Opened Chests from Chest ESP

    Check out "Danger Timer ESP"

- Automation ✅
    - Astral Farm ⚠️⚠️ (optimize route and more stablilty) **REMOVAL SINCE ASTRAL IS ALOT MORE EASIER TO GET + MORE WAYS NOW**
        - Astral Speed ✅
        - Use Carnivore ✅
        - Hunger Level ✅
        - Water Level ✅
        - Webhook Notification ✅
            - Webhook Link ✅
    - Maestro Farm ⚠️⚠️ (auto-eat and optimize route) (they fr can just enchant with gluttony but ok)
        - Use Critical ✅
        - Webhook Link ✅
        - Auto Sell after X amount of Maestro kills ❌
    - Fish Farm ⚠️⚠️⚠️ (rework fish farm)
        - Hold Time ✅
        - Kill Caught Mudskippers ✅
        - Webhook Notification ✅
            - Webhook Link ✅
    - Attribute Farm ✅
        - Auto Charisma Farm ✅
            - Charsima Cap ✅
        - Auto Intelligence Farm ✅
            - Intelligence Cap ✅
    - Effect Automation ✅
        - Auto Extinguish Fire ✅

    Add Auto Loot and Account for Innate Stats

- Exploit ✅
    - Mob Exploits ✅
        - Void Mobs ✅
        - Pathfind Breaker ✅
            - Bring Mobs ✅
            - Real Body Visible ✅
            - Real Body Chams Color ✅
    - Local Character Exploits ✅
        - Move While Knocked ✅

    Check out "Extended Item Pickup"

- Lycoris ✅
    - Cheat Settings ✅
        - Unload Cheat ✅
    - UI Settings ✅
        - Menu Bind ✅
        - Keybind List Bind ✅
    - Theme Manager ✅
    - Save Manager ✅

There are way more features from the old script that are left out.

This is what we have to do right now.
