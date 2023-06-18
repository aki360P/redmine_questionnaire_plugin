Rails.application.routes.draw do
  resources :projects do
    resources :rqre_questionnaires do
      #resources :rqre_questions, only: [:index, :new, :create]
      resources :rqre_questions
      member do
        get :result
        post :vote
        patch :vote
        get :confirm
        post :vote_freeze
      end
    end
    #get 'rqre_questionnaire/:id/result', to: 'rqre_questionnaires#result'
    #post 'rqre_questionnaire/:id/vote', to: 'rqre_questionnaires#vote'
    #post 'rqre_questionnaire/:id/vote', to: 'rqre_questionnaires#vote', as: 'rqre_vote'
    #post 'rqre_questionnaires/:id/vote', to: 'rqre_votes#vote'
    #patch 'rqre_questionnaires/:id/vote', to: 'rqre_votes#vote'
    
  end
  #resources :rqre_questions, only: [:show, :edit, :update, :destroy]
  #post 'rqre_questions/:id/vote', to: 'rqre_votes#vote'

  #get 'rqre_questionnaire/:id/vote', to: 'rqre_questionnaires#vote'
  #patch 'rqre_questionnaire/:id/vote', to: 'rqre_questionnaires#vote'
  #post 'rqre_questionnaire/:id/vote', to: 'rqre_votes#vote'
  #patch 'rqre_questionnaire/:id/vote', to: 'rqre_votes#vote'
  #post 'rqre_questionnaire/:id/vote', to: 'rqre_questionnaires#vote'
  #post 'rqre_questionnaire/:id/vote_freeze', to: 'rqre_votes#vote_freeze'
  get 'rqre_question/:id/result', to: 'rqre_questions#result_question'
end