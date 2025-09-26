class AddPasswordDigestToMembers < ActiveRecord::Migration[8.0]
  def change
    add_column :members, :password_digest, :string
  end
end
