class AddVisitsColumnToMessage < ActiveRecord::Migration
  def change
    add_column :messages, :visits, :integer
  end
end
