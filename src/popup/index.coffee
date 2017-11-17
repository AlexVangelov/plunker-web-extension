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
  controller: ($scope, $mdDialog)->
    port = chrome.runtime.connect
      name: 'plunker'

    userPlunksListener = (msg)->
      if msg.action is 'getUserPlunks'
        if !msg.error
          $scope.userPlunks = msg.data
          $scope.$apply();
        port.onMessage.removeListener userPlunksListener
    
    favoritePlunksListener = (msg)->
      if msg.action is 'getFavoritePlunks'
        if !msg.error
          $scope.favoritePlunks = msg.data
          $scope.$apply();
        port.onMessage.removeListener favoritePlunksListener
    
    $scope.plunkerIcon = require('../img/48.png')
    
    if (githubUserData = localStorage.githubUser)
      $scope.githubUser = JSON.parse githubUserData
      port.onMessage.addListener userPlunksListener
      port.onMessage.addListener favoritePlunksListener
      port.postMessage
        action: 'getUserPlunks'
      port.postMessage
        action: 'getFavoritePlunks'
        
    $scope.openPlunker = ()->
      chrome.tabs.create
        "url": "https://plnkr.co"
        
    $scope.openEditor = ()->
      chrome.tabs.create
        "url": "https://plnkr.co/edit"
    
    $scope.openPlunk = (plunk)->
      chrome.tabs.create
        "url": "https://plnkr.co/edit/#{plunk.id}?p=preview"

    $scope.logout = ()->
      localStorage.clear()
      $scope.githubUser = undefined
        
    $scope.login = ()->
      port.postMessage
        action: 'login'
        
    $scope.filterPlunks = ()->
      filterRegex = new RegExp("#{$scope.filter.toLowerCase()}")
      for plunk in document.getElementsByClassName("plunk-list-item")
        plunk.style.display = if filterRegex.test(plunk.textContent.toLowerCase()) then '' else 'none'
    return