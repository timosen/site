/*
 * using https://github.com/assaf/node-replay and https://github.com/nodejitsu/node-http-proxy
 * to proxy and replay requests to pm.epages.com
 */

var replay = require("replay"),
    httpProxy = require("http-proxy");

var port = process.env.PROXY_PORT || 4040;

console.log("Starting node-replay proxy in '" + replay.mode + "' mode on port " + port);

httpProxy.createProxyServer({
    target: "https://sandbox.epages.com"
  , changeOrigin: true
}).listen(port);
