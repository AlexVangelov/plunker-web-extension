plunkerCreateSession = (callback)->
  fetch "https://api.plnkr.co/sessions",
    credentials: 'include'
    method: 'POST'
    headers:
      "Content-Type": "application/json"
  .then (response)->
    if response.status is 200
      response.json().then (responseJson)->
        localStorage.sessionId = responseJson.id
        callback
          data: responseJson
    else
      callback
        error: response
  .catch (error)->
    callback
      error: error
  
module.exports = plunkerCreateSession