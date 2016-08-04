--#ENDPOINT GET /_init
local ret1 = User.createRole({role_id = "engineer", parameter = {{name = "sn"}}})
local ret2 = User.createRole({role_id = "normal", parameter = {{name = "sn"}}})
local ret = ret1.status_code ~= nil and ret1 or nil
if ret == nil then
  ret = ret2.status_code ~= nil and ret2 or nil
end
if ret ~= nil then
  response.code = ret.status_code
  response.message = ret.message
else
  response.code = 200
end
--#ENDPOINT GET /keystore
obj = Keystore.list()
if (next(obj["keys"])) ~= nil then
  return to_json(obj)
else
  return "no key found"
end
--#ENDPOINT PUT /keystore/{key}
obj = Keystore.get({key=request.parameters.key})
if next(obj) == nil then
  response.message = "add a new one"
else
  response.message = "key existed,update now"
end
ret = Keystore.set({key=request.parameters.key, value=request.body.value})
--#ENDPOINT PATCH /keystore/{key}
obj = Keystore.get({key=request.parameters.key})
if next(obj) ~= nil then
  response.message = "key is existing,update..."
  Keystore.set({key=request.parameters.key, value=request.body.value})
else
  response.message = "key not found"
  return
end
--#ENDPOINT DELETE /keystore/{key}
obj = Keystore.get({key=request.parameters.key})
if next(obj) == nil then
  response.message = "key is not existing"
else
  response.message = "key is existing,delete now"
  Keystore.delete({key=request.parameters.key})
end
--#ENDPOINT POST /email/{mailto}
local emailData = {
  to = request.parameters.mailto,
  subject = "Hello",
  text = request.body.msg,
}
response = Email.send(emailData)
