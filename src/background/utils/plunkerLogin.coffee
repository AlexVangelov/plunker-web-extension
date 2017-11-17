plunkerCreateSession = require './plunkerCreateSession.coffee'
plunkerSetSessionUser = require './plunkerSetSessionUser.coffee'
plunkerLogin = (callback)->
  plunkerCreateSession (msg)->
    if msg.error 
      callback msg
    else
      chrome.windows.create
        url: "https://plnkr.co/auth/github"
        type: 'popup'
        focused: true
        height: 400
        width: 400
      , (window)->
        authListener = (tabId, changeInfo, tab)->
          if tabId is window.tabs[0].id
            if (tab.url.match(/^https?:\/\/plnkr.co\/auth\/github\?code=/) and tab.title.match(/^Plunker/)) 
              chrome.tabs.sendMessage tabId,
                action: "readAuth"
              , (readAuthMsg)->
                chrome.tabs.onUpdated.removeListener authListener
                chrome.windows.remove window.id
                if readAuthMsg and readAuthMsg.auth
                  localStorage.githubToken = readAuthMsg.auth.token
                  localStorage.githubUser = JSON.stringify(readAuthMsg.auth.data)
                  chrome.notifications.create
                    type: 'basic'
                    iconUrl: 'img/128.png'
                    title: "Github authentication OK!"
                    message: readAuthMsg.auth.data.login
                  plunkerSetSessionUser callback
                else #readAuthMsg.auth
                  callback
                    error: 'Authorization failed'
                    data: readAuthMsg
        chrome.tabs.onUpdated.addListener authListener

module.exports = plunkerLogin