plunkerSetSessionUser = (callback)->
  if !localStorage.sessionId or !localStorage.githubToken
    return callback
      error: 'invalid session'
  fetch "https://api.plnkr.co/sessions/#{localStorage.sessionId}/user",
    credentials: 'include'
    method: 'POST'
    headers:
      "Content-Type": "application/json"
    body: JSON.stringify
      service: 'github'
      token: localStorage.githubToken
  .then (setUserResponse)->
    if setUserResponse.status is 201
      setUserResponse.json().then (setUserResponseJson)->
        localStorage.plunkerUser = setUserResponseJson.user.login
        callback
          data: setUserResponseJson
    else
      callback
        error: setUserResponse
  .catch (error)->
    callback
      error: error
module.exports = plunkerSetSessionUser