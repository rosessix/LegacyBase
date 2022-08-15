# LegacyBase - A FiveM component based framework

Made by legacy#0415 or [rosessix](https://github.com/rosessix/) on github or [imzoelol](https://forum.cfx.re/u/imzoelol/summary) on forum.cfx.re.

## LegacyBase is a component based framework for FiveM. The whole idea behind a component based framework is to prevent the need for code to be *re-added* to resources.


The framework is only a "boilerplate" framework. This means, that if you have little to no knowledge of what you are doing, I recommend you to not use the framework and find another.

Currently the framework is a resource work in progress. Suggestion, bug reports, and feature requests are welcome.


### How do I use this component-stuff?
A component is a table with functions within it.
You can create a component by using the `addComponent(name, component)` function.

#### An example of how to add a component
```lua
local myComponent = {} -- this is the table we are gonna add to the base

function myComponent:printMsg(msg) -- This printMsg function is inside of myComponent.
    print(msg)
end

-- Then we will have to add the component to the base.
exports['lg-base']:addComponent('myComponent', myComponent)

--[[
    This code is optional, as this allows the base resource to be restarted without losing the component.
]] 

AddEventHandler('lg-base:Ready', function()
    exports['lg-base']:addComponent('myComponent', myComponent)
end)
```

## Beaware that the component names are case sensitive.
#### But how do I use the component?

Glad you asked! You can do so by doing the following:

```lua
local myComponent = exports['lg-base']:getComponent('myComponent')
-- This will return the component table.
-- You can then use the functions inside of it.
myComponent:printMsg('Hello World!')

-- output:
Hello World!
```

### List of default components:

## Logs
This component is only used for logging.
|Function name |Returns/Does| Param |
| :-------------: | :-------------:| :-----:|
| Log | Logs a message to the console. | Type, string

The default types are: warn, trace, error and critical.

## Database
This component is used to make often used queries easier to use.
|Function name |Returns/Does| Param |	
| :-------------: | :-------------:| :-----:|
| FirstConnection | Checks if its the first time a player connects | Identifier |
| IsPlayerBanned | Checks if the player is banned | Identifier |
| IsPlayerWhitelisted | Checks if the player is Whitelisted | Identifier |
| UpdateGroups | Updates the group json | Identifier, group-table |
| UpdateCashAndBalance | Updates cash and balance | Identifier, user|

## User
This component is the component that takes care of user handling.

|Function name |Returns/Does| Param |
| :-------------: | :-------------:| :-----:|
| CreatePlayer | Creates the player functions| Source|
| GetUser | Returns the user table | Source |
| GetPlayers | Returns a table of all players | None |

The `CreatePlayer` function makes functions *onto* the player.

Example:

```lua
local user = exports['lg-base']:getComponent('User'):GetUser(source)
print(user.isAdmin()) -- prints true/false depending on being an admin or not.
```

You can read all the user-related functions inside of the `CreatePlayer` function.

#### Client sided components only:
### Library
This component is used to make frequently used natives easier to use.

|Function name |Returns/Does| Param |
| :-------------: | :-------------:| :-----:|
| LoadModel | Loads a model and shows and error if not loaded correctly | Model |
| LoadAnimDict | Loads an animation dict  | dict |
| CreateVehicle | Creates a vehicle | x,y,z,h,model,isNetworked
| GetClosestPlayer | Get Closest player | None |
| GetClosestVehicle | Get Closest vehicle | None |
| Draw2DText | Draws 2D text | String |
| Round | Rounds a number to a certain amount of decimals | Number, decimals |