class CreateResultTable < ActiveRecord::Migration
  def change
    create_table :result do |t|
      t.text :messages, array: true, default: []
    end
  end
end
