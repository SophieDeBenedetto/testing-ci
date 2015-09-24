class AddAttributesToResults < ActiveRecord::Migration
  def change
    add_column :results, :sha, :string
    add_column :results, :user, :string
  end
end
