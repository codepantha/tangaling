Rails.application.routes.draw do
  devise_for :users
  get 'home/index'

  authenticate :user do
    resources :timelines,
      only: [:index, :show],
      param: :username
  end

  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end
end
