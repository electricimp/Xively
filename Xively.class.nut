// Copyright (c) 2013 Electric Imp
// This file is licensed under the MIT License
// http://opensource.org/licenses/MIT

// create a namespace
if (!("Xively" in getroottable())) Xively <- {};

class Xively.Client {
    _apiBaseUrl = "https://api.xively.com/v2/"
    _apiKey = null;

	constructor(apiKey, apiBaseUrl = null) {
		this._apiKey = apiKey;

        if (apiBaseUrl != null) this._apiBaseUrl = apiBaseUrl;
	}

	function put(feed){
		local url = _apiBaseUrl + "feeds/" + feed._feedId + ".json";
		local headers = { "X-ApiKey" : _apiKey, "Content-Type":"application/json", "User-Agent" : "Xively-Imp-Lib/1.0" };
		local request = http.put(url, headers, feed.toJson());

		return request.sendsync();
	}

	function get(feed){
		local url = _apiBaseUrl + "feeds/" + feed._feedId + ".json";
		local headers = { "X-ApiKey" : _apiKey, "User-Agent" : "xively-Imp-Lib/1.0" };
		local request = http.get(url, headers);
		local response = request.sendsync();
		if(response.statuscode != 200) {
			server.error("error sending message: " + response.body);
			return null;
		}

		local channel = http.jsondecode(response.body);
		for (local i = 0; i < channel.datastreams.len(); i++) {
			for (local j = 0; j < feed._channels.len(); j++) {
				if (channel.datastreams[i]._id == feed._channels[j]._id) {
					feed._channels[j].current_value = channel.datastreams[i].current_value;
					break;
				}
			}
		}

		return feed;
	}

}

class Xively.Feed{
    _feedId = null;
    _channels = null;

    constructor(feedID, channels) {
        this._feedId = feedID;
        this._channels = channels;
    }

    function getFeedId() { return _feedId; }

    function toJson() {
        local json = "{ \"datastreams\": [";
        for (local i = 0; i < this._channels.len(); i++) {
            json += this._channels[i].toJson();
            if (i < this._channels.len() - 1) json += ",";
        }
        json += "] }";
        return json;
    }
}

class Xively.Channel {
    _id = null;
    _value = null;

    constructor(_id, val = null) {
        this._id = _id;
        this._value = val;
    }

    function set(value) {
        _value = value;
    }

    function get() {
    	return this._value;
    }

    function toJson() {
    	return http.jsonencode({ id = this._id, current_value = this._value });
    }
}
