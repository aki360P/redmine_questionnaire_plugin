Rails.application.routes.draw do
  resources :projects do
    resources :rqre_questionnaires do
      resources :rqre_questions, only: [:index, :new, :create]
    end
  end
  resources :rqre_questions, only: [:show, :edit, :update, :destroy]
  post 'rqre_questions/:id/vote', to: 'rqre_votes#vote'
  get 'rqre_questionnaire/:id/vote', to: 'rqre_votes#index'
  post 'rqre_questionnaire/:id/vote_fix', to: 'rqre_votes#vote_fix'
end