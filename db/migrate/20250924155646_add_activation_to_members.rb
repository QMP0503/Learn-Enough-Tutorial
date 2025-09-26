class AddActivationToMembers < ActiveRecord::Migration[8.0]
  def change
    add_column :members, :activation_digest, :string
    add_column :members, :activated, :boolean, default: false
    add_column :members, :activated_at, :datetime
  end
end
