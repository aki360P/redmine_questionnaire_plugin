class ChangeContentLongtext < ActiveRecord::Migration[4.2]

  def self.up
    change_column :rqre_questions, :content, :longtext
  end

  def self.down
    change_column :rqre_questions, :content, :string
  end

end
