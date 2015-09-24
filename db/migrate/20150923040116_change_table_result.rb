class ChangeTableResult < ActiveRecord::Migration
  def change
    change_column :result, :messages, :text
  end
end
