class UpdateOpenings < ActiveRecord::Migration
  def self.up
    add_column(:openings, :created_at, :datetime)
    add_column(:openings, :updated_at, :datetime)
    add_index(:openings, :updated_at)
  end

  def self.down
    remove_index(:openings, :updated_at)
    remove_column(:openings, :created_at)
    remove_column(:openings, :updated_at)
  end
end
