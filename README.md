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

  api/v1/user

* **HTTP Verb:**
  
  `POST`

* **Payload**

  * username :string *required*
  * email :string *required*
  * password :string *required*
  
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