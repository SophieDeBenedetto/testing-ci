class AddAttributesToResult < ActiveRecord::Migration
  def change
    add_column :result, :pr_id, :string
    add_column :result, :user, :string
  end
end
