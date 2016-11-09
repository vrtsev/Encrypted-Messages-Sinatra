class ChangeColumnInMessage < ActiveRecord::Migration
  def change
    change_table :messages do |t|
      t.change :content, :string
    end
  end
end
