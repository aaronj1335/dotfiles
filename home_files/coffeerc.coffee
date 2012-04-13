global.fs = require 'fs'
global.path = require 'path'
global.u = require 'underscore'

histFile = global.histFile = path.join process.env.HOME, '.coffee_history'

addHistory = () ->
  path.exists histFile, (exists) ->
    if exists
      lines = fs.readFileSync(histFile, 'utf8').split('\n').reverse()
      rli.history = rli.history.concat lines
  rli.addListener 'close', () ->
    s = rli.history.reverse().join('\n')
    fs.writeFile histFile, s, (e) ->
      throw e if e

waitForRli = () ->
  if global.rli
    addHistory()
  else
    setTimeout waitForRli, 100

waitForRli()

