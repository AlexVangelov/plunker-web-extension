chrome.runtime.onMessage.addListener (request, sender, sendResponse)->
  if request.action is "readAuth"
    script = document.querySelector 'script'
    auth = script.text.match(/root._plunker.auth = (.*);/)
    sendResponse
      auth: JSON.parse(auth[1])