class CreateSlugTraps < ActiveRecord::Migration
  def self.up
    create_table(:slug_traps) do |t|
      t.string :slug,         :limit=>100
      t.string :redirect_slug,:limit=>100
      t.string :type,         :limit=>20

      t.timestamps
    end
    add_index :slug_traps, [:type, :slug], :unique=>true
  end

  def self.down
    remove_index :slug_traps, [:type, :slug]
    drop_table :slug_traps
  end
end
