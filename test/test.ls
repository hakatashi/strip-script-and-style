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

  It 'strips all inline <script> elements from input' ->
    run do
      input: '<div>blah <script>document.write("blah")</script> blah</div><script></script>'
      output: '<div>blah  blah</div>'

  It 'strips all referencial <script> elements from input' ->
    run do
      input: '''
        <script src="evil.js"></script>
        <div>just see...<script src="script.js"></script></div>
      '''
      output: '''

        <div>just see...</div>
      '''

  It 'strips all inline <style> elements from input' ->
    run do
      input: '''
        <style>
          body {background: red;}
        </style>
        <body>
          invalid <style>
            body: {display: none;}
          </style> style element
        </body>
      '''
      output: '''

        <body>
          invalid  style element
        </body>
      '''

  It 'strips all referencial styling <link> elements from input' ->
    run do
      input: '''
        <link rel="stylesheet" href="/wtf-style.css">
        <body>
          linking?<link rel="stylesheet" href="/invalid-style.css">
        </body>
      '''
      output: '''

        <body>
          linking?
        </body>
      '''

  It 'only strips <link> tags which does styling' ->
    run do
      input: '''
        <link rel="icon" href="favicon.ico">
        <link rel="prev" rel="stylesheet" href="/wtf-style.css">
        <link rel="stylesheet" rel="next" href="/wtf-style.css">
        <link rel="search" href="search.php">
      '''
      output: '''
        <link rel="icon" href="favicon.ico">


        <link rel="search" href="search.php">
      '''
