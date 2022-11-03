class VoteTableAdd < ActiveRecord::Migration[4.2]
  
  def self.up
    add_column :rqre_votes, :fixed, :integer, after: :answer
  end

  def self.down
    remove_column :rqre_votes, :fixed
  end
end
