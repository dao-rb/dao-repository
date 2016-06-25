# Dao::Repository

[![Build Status](https://travis-ci.org/dao-rb/dao-repository.svg?branch=master)](https://travis-ci.org/dao-rb/dao-repository)
[![Code Climate](https://codeclimate.com/github/dao-rb/dao-repository/badges/gpa.svg)](https://codeclimate.com/github/dao-rb/dao-repository)
[![Test Coverage](https://codeclimate.com/github/dao-rb/dao-repository/badges/coverage.svg)](https://codeclimate.com/github/dao-rb/dao-repository/coverage)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'dao-repository'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install dao-repository

## Usage

```

require 'dao/entity'
require 'dao/repository'
require 'dao/gateway/active_record'

class Comment < ApplicationRecord
end

class Post < ApplicationRecord
  has_many :comments
end

class CommentEntity < Dao::Entity::Base
  attribute :body, String
end

class PostEntity < Dao::Entity::Base
  attribute :id,       Integer
  attribute :body,     String
  
  attribute :comments, Array[CommentEntity]
end

class PostRepository < Dao::Repository::Base
  entity PostEntity
  gateway Dao::Gateway::ActiveRecord::Base, Post, Dao::Gateway::ActiveRecord::BaseTransformer
end

post = PostRepository.last(with: :comments)

post.id # => 1
post.body # => "Post body"
post.comments # => [#<CommentEntity:0x007ffdcb923a30>]
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/dao-rb/dao-repository.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
