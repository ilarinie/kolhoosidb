class AddDefaultThemeToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :default_theme, :string
  end
end
