# Payment workflow

## Setup
On the rails api run:

- `rails db:drop` // drop the current databse

- `rails db:create` // create the database

- `rails db:migrate` // run migrations

- set `STRIPE_SECRET_KEY` in the file `.env`

- `rails s` // start server

### Free Event Registration
`POST`'ing to `/event-registrations` requires you to specify a ticket class.

**If the ticket class you specify has a price of $0**

- The event registration will be created in the databse

- The response status will be `201`

- The response body will contain the record with an `id`

- No further action is needed. You can show the user it was sucessful.

**If the ticket class you specify has a price greater $0**

- The event registration will not be created in the database

- The response status will be `202`

- The response body will not contain an `id`

- The response body will contain a `clientSecret` in the `meta` namespace

- Pass this `clientSectret` to Stripe's SDK to collect a payment source and process the payment

- Rely on Stripe to tell if the payment is complete. The server will listen for the event and create the record when payment is complete.
