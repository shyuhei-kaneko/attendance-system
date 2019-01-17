class CreateFlags < ActiveRecord::Migration[5.1]
  def change
    create_table :flags do |t|
      t.string :admin_flag

      t.timestamps
    end
  end
end
