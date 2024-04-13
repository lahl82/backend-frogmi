# typed: false
# frozen_string_literal: true

Rails.application.routes.draw do
  resources :features do
    member do
      post :comments, action: 'create_comment'
      get :comments
    end

    collection do
      get :refresh
    end
  end
end
