plunkerGetUserPlunks = (callback)->
  if !localStorage.sessionId or !localStorage.plunkerUser
    return callback
      error: 'missing session'
  fetch "https://api.plnkr.co/users/#{localStorage.plunkerUser}/plunks?sessid=#{localStorage.sessionId}"
  .then (userPlunks)->
    if userPlunks.status is 200
      userPlunks.json().then (plunksList)->
        callback
          data: plunksList
    else
      callback
        error: userPlunks
  .catch (error)->
    callback
      error: error
module.exports = plunkerGetUserPlunks