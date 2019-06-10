# budgetr

A simple, yet functional budgeting app (yes the spelling is intentional :sunglasses:)

[![forthebadge](https://forthebadge.com/images/badges/uses-badges.svg)](https://forthebadge.com)

## Dependencies

1. A Postgres database (you can use the docker-compose file to set one up)
2. Yarn/npm for the front-end app
3. Elixir/Mix for the back-end app

## Backend

Since it's a Phoenix app generated with `mix phx.new`, you can just do the following to get started

```bash
cd backend
mix phx.server
```

## Frontend

In a different terminal screen/window

```bash
cd budgetr
yarn start
```

And go to localhost:3000 in a browser to see the app in action.

