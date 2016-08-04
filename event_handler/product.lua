Timeseries.write({
  query = data.alias .. ",identifier=" .. data.device_sn .. " value=" .. data.value[2]
})
local resp = Keystore.get({key = "identifier_" .. data.device_sn})
local value = {
  temperature = "undefined",
  humidity = "undefined",
  uptime = "undefined",
  state = "undefined"
}
if type(resp) == "table" and type(resp.value) == "string" then
  value = from_json(resp.value)
end
value[data.alias] = data.value[2]
value["timestamp"] = data.timestamp/1000
value["pid"] = data.vendor or data.pid
Keystore.set({key = "identifier_" .. data.device_sn, value = to_json(value)})
