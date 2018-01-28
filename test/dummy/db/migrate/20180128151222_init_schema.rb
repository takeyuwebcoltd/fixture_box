class InitSchema < ActiveRecord::Migration[5.1]
  def change
    create_table :authors do |t|
      t.string :name
      t.timestamps
    end

    create_table :books do |t|
      t.string :name
      t.references :author
      t.timestamps
    end

    create_table :book_files do |t|
      t.references :book
      t.string :content_type
      t.timestamps
    end
  end
end
