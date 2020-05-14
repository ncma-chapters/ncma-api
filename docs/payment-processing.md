# Payment workflow

### Event Registration
When you `POST` to `/event-registrations` the response will differ based on the ticket class specified and may require additional steps to complete the registration.

#### Free Event Registrations
If the ticket class you specify has a **price of $0**

- The event registration will be created in the database.

- The response status will be `201`.

- The response body will contain the record with an `id`.

- No further action is needed. You can show the user it was sucessful.

**example request**
```js
// POST /event-registrations
{
  "data": {
    "type": "eventRegistrations",
    "attributes":{
      "data": {
        "firstName": "Kevin",
        "lastName": "Mircovich",
        "email": "kevin@ncmamonmouth.org",
        "title": "Software Engineer",
        "company": "NCMA Monmouth"
      }
    },
    "relationships": {
      "ticketClass": {
        "data": {
          "type": "ticketClasses",
          "id": 1
        }
      }
    }
  }
}
```

**example response**
```js
// status: 201
{
  "data": {
    "id": "1",
    "type": "eventRegistrations",
    "links": {
      "self": "http://localhost:3000/event-registrations/1"
    },
    "attributes": {
      "createdAt": "2020-05-12T04:10:34.765Z",
      "updatedAt": "2020-05-12T04:10:34.765Z",
      "data": {
        "firstName": "Kevin",
        "lastName": "Mircovich",
        "email": "kevin@ncmamonmouth.org",
        "title": "Software Engineer",
        "company": "NCMA Monmouth"
      }
    }
  }
}
```

#### Paid Event Registrations
If the ticket class you specify has a **price greater than $0**

- The event registration **will not** be created in the database.

- The response status will be `202`

- The response body **will not** contain an `id`

- The response body will contain a `clientSecret` in the `meta` namespace

- Pass this `clientSectret` to Stripe's SDK to collect a payment source and process the payment

- Rely on Stripe to tell if the payment is complete. The server will listen for the event and create the Event Registration record in the database when the payment is processed successfully.

**example request**
```js
// POST /event-registrations
{
  "data": {
    "type": "eventRegistrations",
    "attributes":{
      "data": {
        "firstName": "Kevin",
        "lastName": "Mircovich",
        "email": "kevin@ncmamonmouth.org",
        "title": "Software Engineer",
        "company": "NCMA Monmouth"
      }
    },
    "relationships": {
      "ticketClass": {
        "data": {
          "type": "ticketClasses",
          "id": 2
        }
      }
    }
  }
}
```

**example response**
```js
// status: 202
{
  "data": {
    "id": null,
    "type": "eventRegistrations",
    "attributes": {
      "id": null,
      "data": {
        "firstName": "Kevin",
        "lastName": "Mircovich",
        "email": "kevin@ncmamonmouth.org",
        "title": "Software Engineer",
        "company": "NCMA Monmouth"
      },
      "ticketClassId": 2,
      "createdAt": null,
      "updatedAt": null
    }
  },
  "meta": {
    "clientSecret": "pi_a123_secret_b456", // redacted
    "paymentIntent": {
      "id": "pi_abc1234", // redacted
      "object": "payment_intent",
      "status": "requires_payment_method",
      "clientSecret": "pi_a123_secret_b456", // will always be the same as above
      "amount": 250000
    }
  }
}
```

## Testing Locally
On the rails api run:

- `rails db:drop` // drop the current database

- `rails db:create` // create the database

- `rails db:migrate` // run migrations

- `rails db:seed` // seed some data (TicketClass #2 will be a paid one)

- set `STRIPE_SECRET_KEY` in the file `.env`

- `rails s` // start server
