class RqreQuestion < ActiveRecord::Base
  include Redmine::SafeAttributes
  belongs_to :rqre_questionnaire, dependent: :destroy
  has_many :rqre_votes, dependent: :destroy

  #def self.find_by_id(questionnaire_id)
  #  #rqre_questionnaire = RqreQuestionnaire.where(['id = ?', questionnaire_id]).first
  #  rqre_questionnaire = RqreQuestionnaire.where(['id = ?', questionnaire_id]).first
  #  rqre_questionnaire
  #end
  def result
    result = RqreVote.where(rqre_question_id: id, freezed: '1').select(:answer)
    result
  end
end
