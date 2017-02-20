# Dao::Repository

[![Gem Version](https://badge.fury.io/rb/dao-repository.svg)](https://badge.fury.io/rb/dao-repository)
[![Build Status](https://travis-ci.org/dao-rb/dao-repository.svg?branch=master)](https://travis-ci.org/dao-rb/dao-repository)
[![Code Climate](https://codeclimate.com/github/dao-rb/dao-repository/badges/gpa.svg)](https://codeclimate.com/github/dao-rb/dao-repository)
[![Test Coverage](https://codeclimate.com/repos/5777e091620b91007d0001e3/badges/c01a62725cb50df7d9f9/coverage.svg)](https://codeclimate.com/repos/5777e091620b91007d0001e3/coverage)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'dao-repository'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install dao-repository
    
## Built-in methods

Repositories in dao-rb are objects that allow you map your data into entities and save them through data gateway.

Basic methods of each repository:

1. `Repository.all` should return all data.
2. `Repository.find` should find entity with given id. You can return entity with its relations by adding a list of them into the second argument (`Repository.find(1, with: [:author, :comments])`), but your gateway should support eager loading. If entity was not found then method will raise an exception.
3. `Repository.find_by_id` also should find entity with given id, but if it was not found then method return `nil`.
4. `Repository.last` should return last entity. You can return entity with its relations by adding a list of them into the first argument (`Repository.last(with: [:author, :comments])`), but your gateway should support eager loading.
5. `Repository.count` should return count of entities.
6. `Repository.build` should build entity from data object.
7. `Repository.save` should save changes in entity.
8. `Repository.save_all` should save collection of entities.
9. `Repository.delete` should delete entity.
10. `Repository.delete_by_id` should delete entity by id.
11. `Repository.with_transaction(&block)` execute block in transaction if gateway support it.
12. `Repository.with_lock(id, *args, &block)` in transaction: locks (with given arguments) db record with given id, execute block if gateway support it.
13. `Repository.by_criteria` should return entities by given criteria.
14. `Repository.by_criteria_count` should return count of elements by given criteria.

## Usage example

```ruby
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

## Custom methods

You can define custom methods in your repository:

```ruby
class Post < ApplicationRecord
  has_many :comments
  
  scope :deleted, -> { where(deleted: true) }
end

class PostRepository < Dao::Repository::Base
  entity PostEntity
  gateway Dao::Gateway::ActiveRecord::Base, Post, Dao::Gateway::ActiveRecord::BaseTransformer
  
  def self.deleted
    scope.deleted(with: :comments).apply # it will return deleted posts with loaded comments.
  end
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/dao-rb/dao-repository.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
