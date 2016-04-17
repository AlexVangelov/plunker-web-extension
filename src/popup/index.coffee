require 'angular'
require 'angular-material'
require 'angular-material/angular-material.scss'

require './popup.scss'
require './img/pencil.svg'
require './img/account-key.svg'
require './img/verified.svg'
require './img/star.svg'

angular.module 'plunker', ['ngMaterial']
.config ($mdThemingProvider)->
  $mdThemingProvider.theme('default')
  .primaryPalette('blue-grey')
  .accentPalette('orange');

.directive 'plunker', ()->
  template: require('./personal.html')
  controller: ($scope)->
    $scope.plunkerIcon = require('../img/48.png')
    $scope.openPlunker = ()->
      chrome.tabs.create
        "url": "https://plnkr.co"
    $scope.openEditor = ()->
      chrome.tabs.create
        "url": "https://plnkr.co/edit"
    $scope.login = ()->
      #TODO move me to background
      fetch "https://api.plnkr.co/sessions",
        credentials: 'include'
        method: 'POST'
        headers:
          "Content-Type": "application/json"
      .then (response)->
        response.json().then (responseJson)->
          localStorage.sessionId = responseJson.id
          fetch "http://#{responseJson.url}"
          .then (responseSession)->
            responseSession.json().then (responseSessionJson)->
              console.log responseSessionJson
    return