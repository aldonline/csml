chai = require 'chai'
should = chai.should()

csml = require '../lib'

process = (f) -> csml.attach(f)()


describe 'CSML', ->
  it 'should work', ->
    tags = process -> 'a'._()
    tags.should.have.length 2
    tags[0].should.be.a 'object'
    tags[0].tag.should.equal 'a'
  
  it 'should work with more than one tag', ->
    tags = process -> 'a'._() ; 'b'._()
    tags.should.have.length 3
    tags[0].should.be.a 'object'
    tags[0].tag.should.equal 'a'
    tags[1].should.be.a 'object'
    tags[1].tag.should.equal 'b'

  it 'should work with nested tags', ->
    tags = process -> 'a b'._()
    
    tags.should.have.length 2
    
    tags[0].tag.should.equal 'a'
    tags[0].content.should.be.a 'function'

    tags2 = process tags[0].content
    tags2.should.have.length 2
    tags2[0].tag.should.equal 'b'

  it 'should capture return value', ->
    tags = process ->
      'a'._()
      'ret'
    tags.should.have.length 2
    tags[1].should.equal 'ret'

  it 'should parse object arguments', ->
    tags = process -> 'a'._ ( a:'a', b:'b' ), c:'c'
    tags.should.have.length 2
    a = tags[0]
    a.tag.should.equal 'a'
    a.props.should.be.a 'object'
    a.props.a.should.equal 'a'
    a.props.b.should.equal 'b'
    a.props.c.should.equal 'c'

  it 'should treat the _ property as content', ->
    tags = process -> 'a'._ ( a:'a', b:'b' ), c:'c', _: 'content'
    tags.should.have.length 2
    a = tags[0]
    a.tag.should.equal 'a'
    a.content.should.equal 'content'

  it 'should treat the last argument as content', ->
    tags = process -> 'a'._ ( a:'a', b:'b' ), c:'c', 'content'
    tags.should.have.length 2
    a = tags[0]
    a.tag.should.equal 'a'
    a.content.should.equal 'content'


