Path      = require "path"
Octonode  = require "octonode"
ApiConfig = require(Path.join(__dirname, "api_config")).ApiConfig
###########################################################################

class TokenVerifier
  constructor: (token) ->
    @token = token.trim()
    api_config = ApiConfig()
    @api   = Octonode.client(@token, { hostname: api_config().hostname })

  valid: (cb) ->
    @api.get "/user", (err, data, headers) ->
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
