Rails.application.routes.draw do
  resources :projects do
    resources :rqre_questionnaires do
      resources :rqre_questions, only: [:index, :new, :create]
    end
    get 'rqre_questionnaire/:id/result', to: 'rqre_questionnaires#result'
  end
  resources :rqre_questions, only: [:show, :edit, :update, :destroy]
  post 'rqre_questions/:id/vote', to: 'rqre_votes#vote'

  get 'rqre_questionnaire/:id/vote', to: 'rqre_questionnaires#vote'
  patch 'rqre_questionnaire/:id/vote', to: 'rqre_questionnaires#vote'
  #post 'rqre_questionnaire/:id/vote', to: 'rqre_questionnaires#vote'
  post 'rqre_questionnaire/:id/vote_freeze', to: 'rqre_votes#vote_freeze'
  get 'rqre_question/:id/result', to: 'rqre_questions#result_question'
end