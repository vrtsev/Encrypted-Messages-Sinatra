class AddStatusColumn < ActiveRecord::Migration
  def change
    add_column :messages, :status, :integer, default: 0
  end
end
