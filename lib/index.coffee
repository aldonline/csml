collector = require 'collector'

tag_collector = collector()
module.exports = ( f ) ->
  tags = tag_collector.attach(f)()
  retval = tags.pop()
  # the last statement on a block can be a tag
  # or something else. if it is something else
  # then we set the retval property.
  tags.retval = retval unless retval instanceof Tag
  tags


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
      tag_collector t = new Tag [tags[0]].concat args
      # return tag. this is never returned to the end user
      # but we use it internally to detect whether the final
      # statement of a block is a tag or something else ( a retval )
      t
  # recursion
  else 
    assert_tags [tags.shift()], -> assert_tags tags, args