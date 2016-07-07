require! {
  '../': Strip-Stream
  'chai': {expect}
  'concat-stream'
  'stream-to-promise'
}

It = global.it

describe 'I/O' ->
  run = ({input, output}) ~>
    stripper = new Strip-Stream!
    concatter = concat-stream encoding: \string, (string) ->
      expect string .to.equal output
    stripper.pipe concatter
    stripper.end input
    stream-to-promise concatter

  It 'passes normal element through to the output' ->
    run do
      input: '<p>blahblah</p>'
      output: '<p>blahblah</p>'
