Rails.application.routes.draw do
  resources :projects do
    resources :rqre_questionnaires do
      resources :rqre_questions, only: [:index, :new, :create]
    end
  end
  resources :rqre_questions, only: [:show, :edit, :update, :destroy]
end