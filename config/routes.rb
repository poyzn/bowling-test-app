Rails.application.routes.draw do
  scope module: :games do
    root to: 'game#show'
    post 'start', to: 'game#start'
    post 'deliveries', to: 'game#deliveries'
  end
end
