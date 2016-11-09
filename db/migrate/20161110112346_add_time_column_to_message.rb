class AddTimeColumnToMessage < ActiveRecord::Migration
  def change
    add_column :messages, :time, :integer
  end
end
