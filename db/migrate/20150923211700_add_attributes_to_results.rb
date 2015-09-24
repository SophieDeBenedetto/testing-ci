class AddAttributesToResults < ActiveRecord::Migration
  def change
    add_column :results, :pr_id, :string
    add_column :results, :user, :string
  end
end
