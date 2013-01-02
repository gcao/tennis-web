require 'sinatra'
require 'rack-livereload'
require 'sinatra/reloader'
use Rack::LiveReload

set :public_folder, File.expand_path(File.dirname(__FILE__) + '/..')

get '/:file' do
  send_file params[:file]
end

