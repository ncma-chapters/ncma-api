# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).

# Create a venue
v = Venue.new
v.address = { street: "260 1st St. S.", street2: "#200", city: "St. Petersburg", state: "FL", zip: 33701 }
v.save

# Create a published event
e = Event.new
e.name = "Developing Winning Proposals"
e.description = "Developing Winning Proposals is designed to provide you with the nuts and bolts you need to review a request for proposal (RFP), put a proposal together, and develop the detailed cost estimates you need to convince a customer that you can best satisfy their needs. This seminar is designed for everyone involved in the development and response to an RFP. In addition to contract management professionals, this program benefits anyone involved in the acquisition process: managers, directors, financial analysts, engineers, and business development employees, among others."
e.venue_id = v.id
e.published_at = DateTime.now
e.starting_at = DateTime.now + 2.weeks
e.ending_at = DateTime.now + 2.weeks + 2.hours
e.save

# Create some TicketClasses for the event
tc_1 = TicketClass.new
tc_1.name = "Members"
tc_1.price = 0
tc_1.event_id = e.id
tc_1.save

tc_2 = TicketClass.new
tc_2.name = "Non Members"
tc_2.price = 2500
tc_2.event_id = e.id
tc_2.save

