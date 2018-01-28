# FixtureBox
Dynamically creating ActiveRecord Fixtures.

## Usage

```ruby
class Book < ApplicationRecord
  belongs_to :author
  has_many :files, class_name: 'Book::File'
end

class Author < ApplicationRecord
  belongs_to :book
end

class Book::File < ApplicationRecord
  belongs_to :book
end

fixture_data = {
  books: {
    wagahai_wa_neko_de_aru: {
      name: 'Wagahai wa Neko de Aru',
      author: :natsume_soseki
    },
    ame_ni_mo_makezu: {
      name: 'Ame ni mo Makezu',
      author: :miyazawa_kenji
    }
  },
  authors: {
    natsume_soseki: {
      name: 'Natsume Soseki'
    },
    miyazawa_kenji: {
      name: 'Miyazawa Kenji'
    }
  },
  book_files: {
    wagahai_wa_neko_de_aru_zip: {
      book: :wagahai_wa_neko_de_aru,
      content_type: 'application/zip'
    },
    wagahai_wa_neko_de_aru_ebk: {
      book: :wagahai_wa_neko_de_aru,
      content_type: 'application/x-expandedbook'
    }
  }
}
class_names = {
  book_files: Book::File
}

fixture_box = FixtureBox.new(fixture_data, class_names)

assert_equal 'Wagahai wa Neko de Aru', @fixture_box.books(:wagahai_wa_neko_de_aru).name

# belongs_to
assert_equal 'Natsume Soseki', @fixture_box.books(:wagahai_wa_neko_de_aru).author.name

# Set the model class
assert_equal 'application/zip', @fixture_box.book_files(:wagahai_wa_neko_de_aru_zip).content_type 
assert_equal %w(application/zip application/x-expandedbook), @fixture_box.books(:wagahai_wa_neko_de_aru).files.pluck(:content_type)

# Get all instances
assert_equal ['Wagahai wa Neko de Aru', 'Ame ni mo Makezu'], @fixture_box.books.map(&:name)
```

## Installation
Add this line to your application's Gemfile:

```ruby
gem 'fixture_box'
```

And then execute:
```bash
$ bundle
```

Or install it yourself as:
```bash
$ gem install fixture_box
```

## Contributing
Contribution directions go here.

## License
The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
