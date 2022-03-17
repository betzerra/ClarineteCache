require 'sinatra'
require 'sinew'

sinew = Sinew.new(output: 'output.csv', expires: 60)

get '/trends' do
  response = sinew.get 'https://clarinete.seppo.com.ar/api/trends'
  response.body
end