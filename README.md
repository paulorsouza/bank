# Bank

A simple bank app implementing the CQRS/ES pattern using the [Commanded](https://github.com/slashdotdash/commanded) open source library.

## Getting Started

### Prerequisites

  * Erlang: http://erlang.org/doc/installation_guide/INSTALL.html
  * Elixir: https://elixir-lang.org/install.html
  * Phoenix: https://hexdocs.pm/phoenix/installation.html
  * Node and npm: https://nodejs.org/en/download/
  * Postgres: https://www.postgresql.org/download/

#### Alternatives
  
  * Install erlang and elixir with [asdf](https://github.com/asdf-vm/asdf). [Gist](https://gist.github.com/paulorsouza/ce86c918721444738d75429f4a505059) install in mint.
  * Install postgres with [Docker](https://www.docker.com/). [Gist](https://gist.github.com/paulorsouza/214de39e122c19c231ab92a9dc7669e4).


### Install

  * Install dependencies with `mix deps.get`
  * Install Node.js dependencies with `cd assets && npm install`
  * Create and migrate your database with `mix ecto.create && mix ecto.migrate`
  * Create the event store database `mix do event_store.create, event_store.init`
  * You can run seed to initial data `mix run priv/repo/seeds.exs`

### Development

  * Start Phoenix endpoint with `mix phx.server`

    Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

### Unit tests

  * running tests with `mix test`
  
    #### Tags

      * mix test --only web
      * mix test --only api
      * mix test --only eventstore
      * mix test --only readstore
      * mix test --only aggregates


# Dev app url

```
http://localhost:4000
```

# Rest endpoints

**User**
----
   Create new user

* **URL**

  api/v1/users

* **HTTP Verb:**
  
  `POST`

* **Payload**

  * username :string *required*
  * email :string *required*
  * password :string *required*

* **Return**   
  
  * username
  * email

* **Sample:**

  ```javascript
     fetch("http://localhost:4000/api/v1/users", {
        method: "POST",
        headers: {
           "Accept": "application/json",
           'Content-Type': 'application/json'
        },
        body: JSON.stringify({
          username: "username", 
          email: "email@email.com",
          password: "password"
        })
     })
  ```

  ```shell
    $ curl -X POST -d '{"username": "username", "email": "email@email.com", "password": "password"}' -H "Accept: application/json" -H "Content-Type: application/json" http://localhost:4000/api/v1/users
  ```

**Wallet**
----
   Get current balance

* **URL**

  api/v1/wallets

* **HTTP Verb:**
  
  `GET`

* **Payload**

  * credential :string *required* (username or email)
  * password :string *required*
  
* **Return**   
  
  * balance

* **Sample:**

  ```javascript
     fetch("http://localhost:4000/api/v1/wallets?credential=username&password=password", {
        method: "GET",
        headers: {
           "Accept": "application/json",
           'Content-Type': 'application/json'
        }
     })
  ```

  ```shell
    $ curl -X GET -H "Accept: application/json" -H "Content-Type: application/json" http://localhost:4000/api/v1/wallets?credential=username&password=password
  ```

**Withdraw**
----
   Do a withdraw in user wallet

* **URL**

  api/v1/withdraws

* **HTTP Verb:**
  
  `POST`

* **Payload**

  * credential :string *required* (username or email)
  * password :string *required*
  * value :number *required*
  
* **Return**   
  
  * balance

* **Sample:**

  ```javascript
     fetch("http://localhost:4000/api/v1/withdraws", {
        method: "GET",
        headers: {
           "Accept": "application/json",
           'Content-Type': 'application/json'
        },
        body: JSON.stringify({
          credential: "username",
          password: "password",
          value: "200,22"
        })
     })
  ```

  ```shell
    $ curl -X POST -d '{"credential": "username", "password": "password", "value": "200,22"}' -H "Accept: application/json" -H "Content-Type: application/json" http://localhost:4000/api/v1/withdraws
  ```

**Transfer**
----
   Send money to another wallet(you can send to your own wallet :D, this can help in tests)

* **URL**

  api/v1/transfers

* **HTTP Verb:**
  
  `POST`

* **Payload**

  * credential :string *required* (username or email)
  * password :string *required*
  * to_user :string *required* (wallet detination username)
  * value :number *required*
  
* **Return**   
  
  * balance

* **Sample:**

  ```javascript
     fetch("http://localhost:4000/api/v1/transfers", {
        method: "GET",
        headers: {
           "Accept": "application/json",
           'Content-Type': 'application/json'
        },
        body: JSON.stringify({
          credential: "username",
          to_user: "username",
          password: "password",
          value: "200,00"
        })
     })
  ```

  ```shell
    $ curl -X POST -d '{"credential": "username", "password": "password", "to_user": "username", "value": "200,00"}' -H "Accept: application/json" -H "Content-Type: application/json" http://localhost:4000/api/v1/transfers
  ```


