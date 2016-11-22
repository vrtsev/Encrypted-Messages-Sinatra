class AddStatusColumn < ActiveRecord::Migration # :nodoc:
  def change
    add_column :messages, :status, :integer, default: 0
  end
end
