require 'sinatra'
require 'active_record'
require 'pry'
require 'securerandom'
require 'uri'

###########################################################
# Configuration
###########################################################

set :public_folder, File.dirname(__FILE__) + '/public'

configure :development, :production do
    ActiveRecord::Base.establish_connection(
       :adapter => 'sqlite3',
       :database =>  'db/dev.sqlite3.db'
     )
end

# Handle potential connection pool timeout issues
after do
    ActiveRecord::Base.connection.close
end

###########################################################
# Models
###########################################################
# Models to Access the database through ActiveRecord.
# Define associations here if need be
# http://guides.rubyonrails.org/association_basics.html

class Link < ActiveRecord::Base
  def shorten
    # self.code = '123'
    self.update_attribute(:code, SecureRandom.uuid)
    self.code
  end

end

###########################################################
# Routes
###########################################################

get '/' do
  # puts request.url
  # puts Link.find(:all).to_s
  @links = Link.find :all # FIXME
  erb :index
end

get '/new' do
    erb :form
end

get '/:path' do
  url = Link.find(:first, :conditions => { :code => params[:path] })
  puts url.url
  redirect url.url
  #redirect to /code

end

post '/new' do
  url = params[:url]
  link = Link.create! :url => url
  link.shorten
end

# MORE ROUTES GO HERE