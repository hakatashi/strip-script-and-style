require! {
  trumpet
  'readable-stream': {Transform}
}

class Strip-Stream extends Transform
  (@options) -> super ...

  _transform: (chunk, encoding, done) ->
    @push chunk, encoding
    done!

  _flush: (done) ->
    @end!
    done!

module.exports = Strip-Stream
