Octonode  = require "octonode"
Url  = require "url"
###########################################################################

class TokenVerifier
  constructor: (token) ->
    @token = token.trim()
    api_uri = (process.env.HUBOT_GITHUB_API or 'https://api.github.com')
    console.log api_uri
    @api   = Octonode.client(@token, { hostname: api_uri })

  valid: (cb) ->
    @api.get "/user", (err, data, headers) ->
      console.log err
      console.log data
      console.log headers
      scopes = headers? and headers['x-oauth-scopes']
      console.log scopes
      if scopes
        if scopes.indexOf('repo') >= 0
          console.log "repo"
          cb(true)
        else if scopes.indexOf('repo_deployment') >= 0
          console.log "repo_deployment"
          cb(true)
        else
          console.log "scopes, but not right ones"
          cb(false)
      else
        console.log "no scopes"
        cb(false)

exports.TokenVerifier = TokenVerifier
