require "sinatra"
require "json"
require "csv"
require "./fortune"

require "pry"

get "/" do
  redirect to("/fortunes/random")
end

get "/fortunes/random.json" do
  content_type :json
  Fortune.sample.to_json
end

get "/fortunes/random" do
  erb :show, locals: { fortune: Fortune.sample }
end

get "/fortunes/:id" do |id|
  fortune = Fortune.read(id)
  erb :show, locals: { fortune: fortune }
end

get "/fortunes" do
  erb :index, locals: { fortunes: Fortune.all }
end


# AJAX CRUD actions

get "/fortunes/:id.json" do |id|
  fortune = Fortune.read(id)
  if fortune
    status 200
    fortune.to_json
  else
    status 404
  end
end

post "/fortunes.json" do
  if params[:text]
    # 201 Created, Location: /fortunes/:id
    fortune = Fortune.create(params[:text])

    status 201
    headers "Location" => "/fortunes/#{fortune.id}"
  else
    status 400
  end
end

put "/fortunes/:id.json" do |id|
  # 204 No Content, or 404 Not Found if id dne
  fortune = Fortune.read(id)
  if fortune.nil?
    status 404
  else
    Fortune.update(id, params[:text])
    status 204
  end
end

delete "/fortunes/:id.json" do |id|
  # 200 OK, or 404 Not Found if id dne
  fortune = Fortune.read(id)
  if fortune.nil?
    status 404
  else
    Fortune.delete(id)
    status 204
  end
end
