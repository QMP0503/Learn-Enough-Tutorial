class AddAdminToMembers < ActiveRecord::Migration[8.0]
  def change
    add_column :members, :admin, :boolean, default: false
  end
end
