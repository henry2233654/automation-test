start, _ = string.find(request.timer_id, "_")
if start ~= nil then
  local sn = string.sub(request.timer_id, 1, start-1)
  local value = kv_read(sn)
  if value.alerts ~= nil then
    local alert = value.alerts[1]
    local sbj = "Alert for device " .. sn .. ", state " .. alert.state
    Email.send({to = alert.email, from = "noreply@exosite.com", text = alert.message, subject = sbj})
    alert.timer_running = false
    kv_write(sn, value)
  end
end
