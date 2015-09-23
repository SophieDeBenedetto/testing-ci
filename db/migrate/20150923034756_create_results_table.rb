class CreateResultsTable < ActiveRecord::Migration
  def change
    create_table :results do |t|
      t.text :messages, array: true, default: []
    end
  end
end
