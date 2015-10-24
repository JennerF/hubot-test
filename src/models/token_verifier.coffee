Octonode  = require "octonode"
Url  = require "url"
###########################################################################

class TokenVerifier
  constructor: (token) ->
    @token = token.trim()
    api_uri = (process.env.HUBOT_GITHUB_API or 'https://api.github.com')
    parsed_api_uri = Url.parse(api_uri)
    @api   = Octonode.client(@token, { hostname: parsed_api_uri.host })

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
