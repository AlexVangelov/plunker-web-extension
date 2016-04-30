plunkerGetFavoritePlunks = (callback)->
  if !localStorage.sessionId or !localStorage.plunkerUser
    return callback
      error: 'missing session'
  fetch "https://api.plnkr.co/users/#{localStorage.plunkerUser}/thumbed?sessid=#{localStorage.sessionId}"
  .then (plunks)->
    if plunks.status is 200
      plunks.json().then (plunksList)->
        callback
          data: plunksList
    else
      callback
        error: plunks
  .catch (error)->
    callback
      error: error
module.exports = plunkerGetFavoritePlunks