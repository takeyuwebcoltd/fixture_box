class Book < ApplicationRecord
  belongs_to :author
  has_many :files, class_name: 'Book::File'
end
