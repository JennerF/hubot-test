Octonode  = require "octonode"
Url  = require "url"
###########################################################################

class TokenVerifier
  constructor: (token) ->
    @token = token.trim()
    api_uri = process.env.HUBOT_GITHUB_API_URI or 'api.github.com'
    @api   = Octonode.client(@token, { hostname: api_uri })

  valid: (cb) ->
    @api.get "/user", (err, data, body, headers) ->
      scopes = headers? and headers['x-oauth-scopes']
      if scopes
        if scopes.indexOf('repo') >= 0
          cb(true)
        else if scopes.indexOf('repo_deployment') >= 0
          cb(true)
        else
          cb(false)
      else
        cb(false)

exports.TokenVerifier = TokenVerifier
