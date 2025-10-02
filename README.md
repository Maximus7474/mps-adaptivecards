# FiveM Adaptive Cards

<!-- 

If using the adaptiveCardLib, outside of the demo resource. You are required to follow the license of the code (LICENSE file) and keep it linked within the folder along with this README and link towards the original github repository.

> https://github.com/Maximus7474/mps-adaptivecards

 -->

A Lua module for FiveM that simplifies the creation and management of **Adaptive Cards**, enabling rich, interactive UIs for players. This resource handles the complexities of the Adaptive Card JSON schema, allowing you to focus on building your user interface.

## Demonstrations

<details>
  <summary>Generic Demo Card</summary>
  <img src=".github/assets/demo.png" alt="Demo Image" width="600">
</details>

<details>
  <summary>Basic Discord Whitelist</summary>
  <img src=".github/assets/discord-wl-demo-1.png" alt="Demo Image" width="600">
  <img src=".github/assets/discord-wl-demo-2.png" alt="Demo Image" width="600">
  <img src=".github/assets/discord-wl-demo-3.png" alt="Demo Image" width="600">
</details>

<details>
  <summary>Basic Password Protection</summary>
  <img src=".github/assets/password-demo-2.png" alt="Demo Image" width="600">
  <img src=".github/assets/password-demo-1.png" alt="Demo Image" width="600">
</details>

-----

## 🚀 Features

  * **Object-Oriented**: Create cards, containers, and elements using a clean, class-based syntax.
  * **Built-in Elements**: Easily create common Adaptive Card elements like `TextBlock`, `Image`, and `Media`.
  * **Type Safety**: Utilizes LuaDoc for full auto-completion and type-checking in compatible editors (like Visual Studio Code with the Sumneko Lua extension).
  * **FiveM Integration**: Designed to work seamlessly with the `deferrals.presentCard()` function.

-----

## 📦 How to Use

1.  **Download the librairie**: Go to the latest release, download the `lib` archive and place it in your resource.

2.  **Require the Modules**: In your server-side script, import the modules.

    ```lua
    -- These are example paths, it can be different on your server so pay attention
    local Card = require 'server.lib.card'
    local CardElement = require 'server.lib.cardElement'
    local CardContainer = require 'server.lib.cardContainer'
    ```

3.  **Create and Present a Card**: Use the provided classes to construct your card and pass the final JSON string to `deferrals.presentCard()`.

-----

## 📝 Example

This is a demo resource, therefor you can simply install it on your server and start messing around with the `server/index.lua` file to discover the system.
If you want to use this within another resource, extract the `lib/` folder and place it into your resource. Please note that this **does require ox_lib** which "fixes" the lua require feature within fxserver, it can be altered to not use it but that is solely on you to do and work it out (because it's not hard, figure it out).
