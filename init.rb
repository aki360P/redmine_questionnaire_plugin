#require File.expand_path('../lib/rqre_projects_helper_patch', __FILE__)

Redmine::Plugin.register :redmine_questionnaire_plugin do
  name 'Redmine questionnaire plugin'
  author 'Akinori Iwasaki'
  description 'Add questionnaire function'
  version '0.3.0'
  url 'https://github.com/aki360P/redmine_questionnaire_plugin'
  
  project_module :redmine_questionnaire_plugin do
    permission :view_rqre_questionnaires, {:rqre_questionnaires => [:index, :show]}
    permission :edit_rqre_questionnaires, {:rqre_questionnaires => [:edit, :update, :new, :create], :rqre_questions => [:edit, :update, :new, :create]}
    permission :view_rqre_questions, {:rqre_questions => [:index, :show], :rqre_questionnaires => [:vote, :confirm, :result, :vote_freeze]}  #permission name can't be changed because it connects to attachments controller. This permission is used as a voting permission
  end
  
  
  # add tab - project module
  menu :project_menu, :rqre_questionnaires, {:controller => 'rqre_questionnaires', :action => 'index' }, :caption => :label_rqre, :param => :project_id
  
  # setting
  settings  partial: 'rqre_global_settings/show',
            default: {
              'rqre_gb1' => 'false'
               }
end