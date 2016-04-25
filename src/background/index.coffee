plunkerLogin = require './utils/plunkerLogin.coffee'
plunkerGetUserPlunks = require './utils/plunkerGetUserPlunks.coffee'

chrome.runtime.onConnect.addListener (port)->
  if port.name is 'plunker'
    plunkerMessageListener = (msg)->
      portResponse = (data)->
        if port
          data.action = msg.action
          port.postMessage data
      switch msg.action
        when 'login'
          plunkerLogin portResponse
        when 'getUserPlunks'
          plunkerGetUserPlunks portResponse
      
    port.onMessage.addListener plunkerMessageListener
    port.onDisconnect.addListener ()->
      port.onMessage.removeListener plunkerMessageListener
      port = undefined
      