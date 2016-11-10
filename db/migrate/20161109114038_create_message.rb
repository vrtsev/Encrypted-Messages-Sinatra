class CreateMessage < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.string :content
      t.string :mode
      t.integer :time
      t.integer :visit_count, default: 0
      t.integer :visits, default: 0
      t.timestamps
    end
  end
end 
