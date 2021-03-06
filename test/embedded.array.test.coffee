describe 'embedded.array', ->
  mabolo = new Mabolo mongodb_uri

  describe 'create array of string', ->
    Book = mabolo.model 'Book',
      name: String
      tags: [String]

    it 'construct and save', ->
      book = new Book
        name: 'SICP'
        tags: ['lisp', 'scheme']

      return book.save()

    it 'create empty array', ->
      Book.create
        name: 'SICP'
      .then (book) ->
        book.tags.should.be.eql []

  describe 'create array of model', ->
    Token = mabolo.model 'Token',
      code: String

    User = mabolo.model 'User',
      name: String
      tokens: [Token]

    it 'construct and save', ->
      token = new Token
        code: '03b9a5f0d18bc6b6'

      jysperm = new User
        name: 'jysperm'
        tokens: [token, token]

      jysperm.toObject().tokens[0].should.not.instanceof Token

      jysperm.save().then ->
        jysperm.tokens[0].should.be.instanceof Token

    it 'create document', ->
      User.create
        name: 'jysperm'
        tokens: [
          {code: '1'}, {code: '2'}
        ]
      .then (jysperm) ->
        _.pluck(jysperm.tokens, 'code').should.be.eql ['1', '2']

  describe 'update documents', ->
