class AddFacilitiesSummaryNormalOpenings < ActiveRecord::Migration
  def self.up
    add_column('facilities', 'summary_normal_openings', :string)
  end

  def self.down
    remove_column('facilities', 'summary_normal_openings')
  end
end
