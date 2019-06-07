# schemas

Here is the outline for the schemas for the budgeting app.

I aim to keep it as simple, yet still useful as possible, largely since I'm still getting used to Elixir/Phoenix.

## User

* id(id)
* first_name(string)
* last_name(string)
* email(string)
* external_id(string|null) if logging in from an external IdP

## Transaction

* id(id)
* datetime_occurred(datetime): time transaction was recorded
* amount(int): amount of the transaction in cents (to prevent floating point rounding errors)
* description(string)
* category(string)
* user_id(id)

## UserMonthlyGoal

* user_id(id)
* month(int:1-12)
* year(smallint)
* amount(int): max amount, in dollars, the users wants to spend in the month
