class CreateRevisionRedirects < ActiveRecord::Migration[5.2]
  def change
    create_table :revision_redirects do |t|
      t.boolean :revision_redirect
      t.boolean :diff_redirect
      t.boolean :repository_redirect
      t.string :revision_link
      t.string :diff_link
      t.string :repository_link
      t.integer :repository_id
    end
    add_index :revision_redirects, :repository_id
  end
end
