# Routehappy API

A light sinatra API to list and upload photos.

[![Build Status](https://travis-ci.org/smeriwether/routehappy-api.svg?branch=master)](https://travis-ci.org/smeriwether/routehappy-api)

## Overview

The API has 2 endpoints:

* GET /images
* POST /image

The GET /images endpoint will return a list of base64 encoded data representing the files on disk. The json response will look like:
```
"images" => [
  {
    "filename" => "file1.jpg",
    "contents" => "/9j/4AAQSkZ..."
  },
  . . .
]
```

This approach has some benefits but also downsides. A benefit of this is that the frontend only needs to make 1 request to load every image. A downside is that the payload is large. The filesize limit is 5000x5000 so I was comfortable using this approach for this problem.

## How to run

* `bundle install`
* `ruby app.rb`


## Requirements

* ruby 2.4.1
* bundler
