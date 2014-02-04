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
    self.code = (SecureRandom.uuid).slice(0, 4)
    self.code
  end

  def addVisit
    self.visits = self.visits + 1
    self.save
    puts "inside Addvisit" + self.visits.to_s
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
  link = Link.find(:first, :conditions => { :code => params[:path] })
  if link != nil
    link.addVisit
    puts "get :path" + link.inspect #read_attribute(:visits).to_s
    redirect link.url
  else
    erb :error
  end
end

post '/new' do
  url = params[:url]
  link = Link.find_or_create_by_url(url) do |l|
    l.shorten
  end

  link.code
end

# MORE ROUTES GO HERE