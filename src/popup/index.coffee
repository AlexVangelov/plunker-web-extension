require 'angular'
require 'angular-material'
require 'angular-material/angular-material.scss'

require './popup.scss'

angular.module 'plunker', ['ngMaterial']
.directive 'plunker', ()->
  template: require('./personal.html')