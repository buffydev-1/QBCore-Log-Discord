# Custom Multiplayer/Singleplayer Log with Webhook Integration

This script provides advanced logging functionality for FiveM servers running on the QBCore framework. It includes logging for various events such as player actions, resource starts/stops, txAdmin events, explosions, and player aims. Logs are sent to a configurable webhook for easy monitoring and tracking.

## Features

- **Custom Multiplayer/Singleplayer Log**
- **Player Join/Leave Events**
- **Resource Start/Stop Logs**
- **txAdmin Events (Ban, Kick, Warn, Announcement, Shutdown)**
- **Player Aim Logs (Player Info, Weapon, Distance)**
- **Explosion Logs (Detailed with Coordinates, Player Info, and Screenshot)**
- **Webhook Integration for Remote Logging**

## Installation

1. **Download the repository** and extract it into your `resources` folder.

2. **Configure the webhook** URL in the `config.lua` file:
   - Open `config.lua` and set your desired Webhook URL.
   - Example:
     ```lua
     Config.WebhookURL = 'https://your-webhook-url-here'
     ```

3. **Start the resource**:
   - Add the following line to your `server.cfg`:
     ```
     start qb-logs
     ```

4. **Optional - Modify Config**:
   - In the `config.lua` file, you can enable or disable specific logging features by changing the values for each option.
     ```lua
     Config.LogPlayerJoinLeave = true  -- Enable player join/leave logging
     Config.LogResourceEvents = true  -- Enable resource start/stop logging
     Config.LogTxAdminEvents = true  -- Enable txAdmin event logging
     Config.LogPlayerAim = true  -- Enable player aim logging
     Config.LogExplosions = true  -- Enable explosion logging
     ```

## Commands

- **`/logPlayerAim`**: Log a player's aim towards another player (activated when aiming at a target).
  
## Usage

Once the resource is loaded, the script will automatically log various in-game events such as:
- Player join and leave events.
- Resource start and stop events.
- txAdmin events like ban, kick, warn, and shutdown.
- Player aiming logs, including the weapon, target, and distance.
- Explosion logs, including a screenshot of the event.

Logs will be sent to the configured webhook and saved to a local file (`custom_logs.txt`), which you can access for further analysis.

## Example Log

Here's an example of how a log entry might look:
