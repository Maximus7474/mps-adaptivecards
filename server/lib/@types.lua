---@class handoverData : table<string, any>
---@class endpoint string[]

---@class Deferrals
---@field done fun(failureReason?: string) (optional) if provided will refuse the connection with the specified reason
---@field defer fun() will initialize deferrals for the current resource. It is required to wait for at least a tick after calling
---@field update fun(message: string) will send a progress message to the connecting client
---@field presentCard fun(card: table | string, cb?: fun(data: table, rawData: string)) can be an object containing card data, or a serialized JSON string with the card information<br>cb, if present, will be invoked on an Action.Submit event from the Adaptive Card
---@field handover fun(data: handoverData) allows you to provide a set of endpoints for a specific player on connection
