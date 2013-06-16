chai = require 'chai'
should = chai.should()

csml = require '../lib'

describe 'CSML', ->
  it 'should work', ->
    tags = do csml.attach -> 'a'._()
    tags.should.have.length 2
    tags[0].should.be.a 'object'
    tags[0].tag.should.equal 'a'

  it 'should work using shortcut form', ->
    tags = csml -> 'a'._()
    tags.should.have.length 2
    tags[0].should.be.a 'object'
    tags[0].tag.should.equal 'a'
  
  it 'should work with more than one tag', ->
    tags = csml -> 'a'._() ; 'b'._()
    tags.should.have.length 3
    tags[0].should.be.a 'object'
    tags[0].tag.should.equal 'a'
    tags[1].should.be.a 'object'
    tags[1].tag.should.equal 'b'

  it 'should work with nested tags', ->
    tags = csml -> 'a b'._()
    
    tags.should.have.length 2
    
    tags[0].tag.should.equal 'a'
    tags[0].content.should.be.a 'function'

    tags2 = csml tags[0].content
    tags2.should.have.length 2
    tags2[0].tag.should.equal 'b'

  it 'should capture return value', ->
    tags = csml ->
      'a'._()
      'ret'
    tags.should.have.length 2
    tags[1].should.equal 'ret'

  it 'should parse object arguments', ->
    tags = csml -> 'a'._ ( a:'a', b:'b' ), c:'c'
    tags.should.have.length 2
    a = tags[0]
    a.tag.should.equal 'a'
    a.props.should.be.a 'object'
    a.props.a.should.equal 'a'
    a.props.b.should.equal 'b'
    a.props.c.should.equal 'c'

  it 'should treat the _ property as content', ->
    tags = csml -> 'a'._ ( a:'a', b:'b' ), c:'c', _: 'content'
    tags.should.have.length 2
    a = tags[0]
    a.tag.should.equal 'a'
    a.content.should.equal 'content'

  it 'should treat the last argument as content', ->
    tags = csml -> 'a'._ ( a:'a', b:'b' ), c:'c', 'content'
    tags.should.have.length 2
    a = tags[0]
    a.tag.should.equal 'a'
    a.content.should.equal 'content'