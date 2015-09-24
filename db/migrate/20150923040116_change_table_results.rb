class ChangeTableResults < ActiveRecord::Migration
  def change
    change_column :results, :messages, :text
  end
end
