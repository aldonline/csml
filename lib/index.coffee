collector = require 'collector'

tag_collector = collector()
x = ( f ) -> tag_collector.attach(f)()

# You could wrap this function as a combinator manually.
# However, since we are using a combinator internally,
# exposing this method directly saves us from creating two extra function objects.
# If the implementation changes we can keep this API. No harm done;
x.combinator = tag_collector.attach

module.exports = x


class Tag
  constructor: ( args ) ->
    throw new Error 'no arguments' if args.length is 0
    # 1. tag, id, classes come first
    @tag = args.shift()
    # 2. optional content comes last. can be anything but an object
    # if you wish content to be an object then pass a function that
    # returns an object
    @content = args.pop() if typeof args[-1..][0] isnt 'object'
    # 3. the rest are property maps
    @props = {}
    has_prop = no
    for arg in args when typeof arg is 'object'
      for own k, v of arg
        has_prop = yes
        @props[k] = v

    delete @content unless @content?
    delete @props unless has_prop

String::_ = ->
  assert_tags @, Array::slice.apply arguments
  # it is important to return undefined
  # if this is the last statement on a block then
  # this would be the return value
  undefined

assert_tags = ( tags, args ) ->
  # special case
  if tags is '' then tags = ['']

  if tags instanceof Array
    tags = tags.concat() # operate on a copy!
  else # process a string separated by one space
    tags = ( x.trim() for x in tags.split ' ' when x isnt '' )

  # check for end of recursion
  if tags.length is 1
      tag_collector new Tag [tags[0]].concat args
  # recursion
  else 
    assert_tags [tags.shift()], -> assert_tags tags, args