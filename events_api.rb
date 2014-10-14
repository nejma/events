require 'sinatra'
require 'active_record'
require 'json'

#======================================================
# Sqlite3 Database: events.db
# One table: create table event ( 
#	event_id INT PRIMARY_KEY NOT NULL, 
#	data CHAR(100)
#	);
#  insert into event(event_id, data) values ( 2, "LATITUDE_2/LONGITUDE_2")

#set :database, 'sqlite://events.db'


#======================================================
# ActiveRecord (Model)

ActiveRecord::Base.logger = Logger.new(STDERR)
ActiveRecord::Base.include_root_in_json = false
ActiveRecord::Base.establish_connection(
	:adapter => "sqlite3",
	:host => "localhost",
	:username => "root",
	:password => "",
	:database => "events.db"	
	)

#======================================================
# class Event inherits from ActiveRecord 
class Events < ActiveRecord::Base
end

#======================================================
# Initially no event record exists in the events database
# So let's create a couple of events to get going....
#======================================================
Events.destroy_all

Events.create(:event_id => 1,
	:data => 'NAME is now at LATITUDE_1/LONGITUDE_1')
 
Events.create(:event_id => 2,
	:data => 'NAME is now at LATITUDE_2/LONGITUDE_2')

# print to check output in console
puts Events.find(1).as_json(only: [:data])
puts Events.find(2).as_json(only: [:data])
puts Events.find(1).data.as_json(only: [:data])

# Not used
def get_events()
	self.Events.all
end



#======================================================
# REST API
#======================================================

get '/events' do 
	#"return all events available"
	# Events.get_events()
	event_array = Array.new
	
	# Events.all
	events = Events.all
	events.each do |ev|
		event_array.push ev.data.as_json(only: [:data])	
	end
	
	# Build the response
	body = ""
	event_array.each do |ev|
		body += ev + "<br/>"
	end
	doc = "<html><body>" + body + "</body></html>" 
end

get '/events/?:event_id?' do
	#" return event of ID # <event_id>"
	
	event_id = -1
	if ! params[:event_id].nil?
		event_id = params[:event_id]
	end
	
	# Search AR: find() method requires Exception handling
	begin
		event = Events.find( event_id ).data.as_json(only: [:data])
	rescue ActiveRecord::RecordNotFound => e
		event = "No record #" + event_id + " found!"
	end 
	
	# Build the response
	doc = "<html><body>" + event + "</body></html>" 
	
end

delete '/events' do
	#"delete all event records in database"
	Events.delete_all
end

delete '/events/?:event_id?' do                                                        
	#"delete record #<event_id> in database"
	
	event_id = -1
	if ! params[:event_id].nil?
		event_id = params[:event_id]
	end		
	Events.find( event_id ).destroy
	puts "Deleted record #" + event_id + "!"
end



post '/events/?:event_id?' do
	#"update or create - if not already there - an entry in database with data sent"
	this_event_id = -1
	if ! params[:event_id].nil?
		this_event_id = params[:event_id]
	end	
	puts params
	request_data = request.body.read
	data_token = request_data.split(':').first
	text_token = request_data.split(':').last 
	
	# Update if exists:
	# Alt. : EventAPI.update( event_id, data: text_token )
	if Events.exists?( this_event_id )
		event.data = request_data.split(':').last
		events.save
		# or:
		#events.update_attributes(this_event_id)
		
	# Create if not exists
	else
		Events.create(event_id: this_event_id, data: request_data.split(':').last)
	end
end




