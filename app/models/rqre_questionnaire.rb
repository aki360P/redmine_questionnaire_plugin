class RqreQuestionnaire < ActiveRecord::Base
  include Redmine::SafeAttributes
  belongs_to :project, optional: true
  has_many :rqre_questions, dependent: :destroy

  acts_as_attachable
  
  #def self.find_by_id(questionnaire_id)
  #  #rqre_questionnaire = RqreQuestionnaire.where(['id = ?', questionnaire_id]).first
  #  rqre_questionnaire = RqreQuestionnaire.where(['id = ?', questionnaire_id]).first
  #  rqre_questionnaire
  #end



end
