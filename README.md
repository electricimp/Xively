# Xively

This library wraps [Xively’s public API](https://xively.com/dev/docs/api/), which allows you to push and get time-series data, as well as configure callbacks that can be triggered through Xively’s _triggers.

The Xively library consists of three classes, which are required to interact with the Xively service:
 - Xively.Client &ndash; Used to send requests to the Xively Service
 - Xively.Feed &ndash; A representation of a Xively feed consisting of one or more channels
 - Xively.Channel &ndash; A representation of a Xively Channel

In order to push data to Xively, we need to instantiate a Xively.Client object with our API key, create Xively.Channel objects for the data we wish to push, then pass those channels into a Feed, which we can then send to the Xively service with **Xively.Client.put()**.

**Note** The current implementation of this library makes synchronous requests when *Xively.Client.get()* and *Xively.Client.put()* are called.

**To add this library to your project, add** `#require "Xively.class.nut:1.0.1"` **to the top of your agent code**

## Xively.Client

## Constructor: Xively.Client(*apiKey, [baseURL]*)

To create a new Xively client, you need to call the constructor with your Xively API key. You can override the default base URL of ```https://api.xively.com/v2/``` by supplying an optional second parameter.

```squirrel
client <- Xively.Client("<YOUR_API_KEY>")
```

## Xively.Client.get(*feed*)

Retreives the current value of a specified feed from Xively:

```squirrel
client <- Xively.Client("<YOUR_API_KEY>")

local tempChannel = Xively.Channel("Temperature")
local tempFeed = Xively.Feed("<MY_FEED_ID>", [tempChannel])
client.get(tempFeed)
local temp = tempChannel.get()
```

## Xively.Client.put(*feed*)

Sends the specified feed (and the data it contains) to Xively:

```squirrel
client <- Xively.Client("<YOUR_API_KEY>")

device.on("temp", function(temp) {
	local tempChannel = Xively.Channel("Temperature", temp)
	local tempFeed = Xively.Feed("<MY_FEED_ID>", [tempChannel])
	client.put(tempFeed)
});
```

## Xively.Feed

## Constructor: Xively.Feed(*feedId, ArrayOfChannels*)

To create a Xively.Feed object, you need to pass a Feed ID (which can be retrieved from your Xively dashboard), and an array of Xively.Channel objects representing the channels in the feed:

```squirrel
local tempChannel = Xively.Channel("Temperature")
local tempFeed = Xively.Feed("<MY_FEED_ID>", [tempChannel])
```

## Xively.Feed.getFeedId()

To get the Feed ID of a previously instantiated Xively.Feed object, call the *getFeedId()* method:

```squirrel
local feedId = tempFeed.getFeedId()
```

## Xively.Channel

## Constructor: Xively.Channel(*channelName, [value]*)

To create a Xively.Channel object, you need to specify the channel name and, optionally, an initial value. The initial value is typically specified when we plan to immediatly send the channel’s data to Xively:

```squirrel
client <- Xively.Client("<YOUR_API_KEY>")

// Create a channel to send data

device.on("temp", function(temp) {
	local tempChannel = Xively.Channel("Temperature", temp)
	local tempFeed = Xively.Feed("<MY_FEED_ID>", [tempChannel])
	client.put(tempFeed)
})
```

```squirrel
client <- Xively.Client("<YOUR_API_KEY>")

// Create a channel to get data

local tempChannel = Xively.Channel("Temperature")
local tempFeed = Xively.Feed("<-- MY_FEED_ID -->", [tempChannel])
client.get(tempFeed)

local temp = tempChannel.get()
```

## Xively.Channel.get()

The *get()* method returns the current value stored in the Xively Channel. This method does **not** retreive information from Xively. To retreive information from Xively, you must call *Xively.Client.Get()*.

```squirrel
local tempChannel = Xively.Channel("Temperature", 21)

// Logs 21

server.log(tempChannel.get())
```

## Xixvely.Channel.set(*value*)

The **set** method sets the current value of the Xively Channel (NOTE: This method does not send information to Xively - to send information to Xively, you must call Xively.Client.Set).

```squirrel
client <- Xively.Client("<YOUR_API_KEY>")

tempChannel <- Xively.Channel("Temperature")
tempFeed <- Xively.Feed("<-- MY_FEED_ID -->", [tempChannel])

device.on("temp", function(temp) {
	tempChannel.set(temp)
	client.put(tempFeed)
})
```

## License

The Xively library is licensed under the [MIT License](./LICENSE).
