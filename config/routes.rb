class ActionDispatch::Routing::Mapper
  def draw routes_name
    instance_eval File.read(Rails.root.join("config/routes/#{routes_name}.rb"))
  end
end

Rails.application.routes.draw do
  get 'rauks/s'

  draw :api
  devise_for :users, :controllers => {:omniauth_callbacks => "users/omniauth_callbacks"} 
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end