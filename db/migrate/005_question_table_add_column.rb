class QuestionTableAddColumn < ActiveRecord::Migration[4.2]

  def self.up
    add_column :rqre_questions, :content, :string
    add_column :rqre_questions, :option, :string
  end

  def self.down
    remove_column :rqre_questions, :content, :string
    remove_column :rqre_questions, :option, :string
  end

end
