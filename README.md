# bzn_allowlist - RC 1

**Version:** RC 1
**Created by:** BenZoN

## Requirements

[fivem-mysql-async v3.0.x](https://github.com/brouznouf/fivem-mysql-async) or [oxmysql](https://github.com/overextended/oxmysql)

## Optional

[esx-legacy](https://github.com/esx-framework/esx-legacy/tree/main/%5Besx%5D)
[ConnectQueue](https://github.com/Nick78111/ConnectQueue)

## Credits

locale.lua - [esx-legacy](https://github.com/esx-framework/esx-legacy/tree/main/%5Besx%5D)
My close friends, for supporting in me what ever I decide to do!

## Note

The current version is a release candidate it should work with out major issues, but wont do a full release before im sure it's stable.

## Description

Back in 2019 I released DRP_WHITELIST, and I knew I wanted to rewrite the allowlist script at some point, since I learned a lot the last two years.

Supported identifiers are steam: and license:, I wont add support for other identifiers, since they don’t fit the scope of bzn_allowlist.

Like I mentioned back when I released DRP_WHITELIST, most allowlist scripts back then did not allow you to allowlist on the fly, and most required you to know the Steam Hex id to whitelist a steam identifier, this script supports Steam64 identifiers, and auto converts them to Steam Hex.

Decided to add support for ConnectQueue, just a very simple and basic integration using the “exports” not true exports to be honest, to add players to the priority list of ConnectQueue, but it’s there, it works and is a nice to have feature if you use ConnectQueue that is, can be fully turned off.

Last time I based the commands on  essentialmode, but this time around I decided to add support for esx legacy ESX.RegisterCommand, and normal vanilla CFX RegisterCommands, with Ace permissions, so finally the resource can be used 100% standalone, and with what ever framework you want to use it with.

Tried to optimize the script even more than the original.

## New Features

Ace Permission support (command.allowlist)
ConnectQueue integration
Auto allowlist the first person to connect (can be disabled, and will be auto disabled if there is id's in the allowlist)

## Features

- Supports Steam64 (steam:*****************)
- Supports Steam Hex (steam:*****************)
- Supports License ID (license:*****************)
- Simple SteamID validation length check, if Steam64 length should be 17, if Hex length should be 15 with out prefix
- Simple License ID validation lenght check, length should be 40 with out prefix
- Supports rcon with RconPrint reply
- Ace Permissions (RegisterCommand)
- ESX RegisterCommand and permissions
- ConnectQueue support control players priority, if priority is 0 (default) the script won’t add priority for the given id.

## Commands

- /+allowlist (ex. /+allowlist steam:76561197960287930) - with priority (ex. /+allowlist steam:76561197960287930 5) 
- /-allowlist (ex. /-allowlist steam:1100001000056ba)
- /priority (ex. /priority steam:1100001000056ba 5)
- /reloadallowlist

## Installation

- Download - https://github.com/benzon/bzn_allowlist/archive/refs/tags/RC-1.zip
- Copy bzn_allowlist to your `resource` folder
- Add ensure `bzn_allowlist` in your `server.cfg` (if you are using ESX and/or ConnectQueue make sure to start the resource after these to)
- Import bzn_allowlist.sql to your database

## Legal

DRP_WHITELIST - DRP Whitelist

Copyright (C) 2015-2019 BenZoN

This program Is free software: you can redistribute it And/Or modify it under the terms Of the GNU General Public License As published by the Free Software Foundation, either version 3 Of the License, Or (at your option) any later version.

This program Is distributed In the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty Of MERCHANTABILITY Or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License For more details.

You should have received a copy Of the GNU General Public License along with this program. If Not, see http://www.gnu.org/licenses/.