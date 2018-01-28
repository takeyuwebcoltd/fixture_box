require 'test_helper'

class FixtureBox::Test < ActiveSupport::TestCase

  test 'Use ActiveRecord fixtures' do
    # fixtures/*.yml
    assert_equal 'Hashire Melos', books(:hashire_melos).name
    assert_equal 'Dazai Osamu', authors(:dazai_osamu).name
    assert_equal 'zip', book_files(:hashire_melos_zip).content_type
    assert_equal books(:hashire_melos).author, authors(:dazai_osamu)
    assert_equal books(:hashire_melos).files.first, book_files(:hashire_melos_zip)
  end

  test 'Use FixtureBox fixtures' do
    # fixtures/*.yml
    assert_equal 'Hashire Melos', books(:hashire_melos).name

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

    assert_equal 'Wagahai wa Neko de Aru', fixture_box.books(:wagahai_wa_neko_de_aru).name

    # belongs_to
    assert_equal 'Natsume Soseki', fixture_box.books(:wagahai_wa_neko_de_aru).author.name

    # Set the model class
    assert_equal 'application/zip', fixture_box.book_files(:wagahai_wa_neko_de_aru_zip).content_type
    assert_equal %w(application/zip application/x-expandedbook), fixture_box.books(:wagahai_wa_neko_de_aru).files.pluck(:content_type)

    # Get all instances
    assert_equal ['Wagahai wa Neko de Aru', 'Ame ni mo Makezu'], fixture_box.books.map(&:name)
  end

  test 'Change a accessor name' do
    fixture_box = FixtureBox.new({
                                   my_books: {
                                     sample: {
                                       author: :sample,
                                       name: 'Sample Book'
                                     }
                                   },
                                   book_authors: {
                                     sample: {
                                       name: 'Sample Author'
                                     }
                                   }
                                 },
                                 {
                                   my_books: Book,
                                   book_authors: Author
                                 })
    assert_equal 'Sample Book', fixture_box.my_books(:sample).name
    assert_equal 'Sample Author', fixture_box.book_authors(:sample).name
  end

  test 'Use Multiple FixtureBox' do
    fixture_box_a = FixtureBox.new(books: { a: { name: 'Book A' } }, authors: { a: { name: 'Author A' } })
    fixture_box_b = FixtureBox.new(books: { b: { name: 'Book B' } }) # DELETE from "books"; INSERT INTO "books" ...
    assert_raise(ActiveRecord::RecordNotFound) { fixture_box_a.books(:a) }
    assert_equal 'Book B', fixture_box_b.books(:b).name
    assert_equal 'Author A', fixture_box_a.authors(:a).name

    fixture_box_c = FixtureBox.new({ my_books: { c: { name: 'Book C' } } }, my_books: Book) # DELETE from "books"; INSERT INTO "books" ...
    assert_raise(ActiveRecord::RecordNotFound) { fixture_box_b.books(:b) }
    assert_equal 'Book C', fixture_box_c.my_books(:c).name
  end
end
