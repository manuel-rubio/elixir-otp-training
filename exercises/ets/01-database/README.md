# Database

Implement a database using an ETS table.

This project has a GenServer stubbed out in the `Database`-module, and
there is a Supervisor in the `Database.Application` module, that is
started when the project is started using `iex -S mix`.

The Database should support the following functions

- `insert(key, value)` -> `:ok` | `{:error, :key_already_exists}`
- `get(key)` -> `{:ok, value}` | `:not_found`
- `update(key, value)` -> `:ok` | `:not_found`
- `delete(key)` -> `:ok`

The functions from the public interface is stubbed in the `Database`
module, and unit tests are provided in the `test/database_test.exs`
file but the tests are skipped; so be sure to remove the skipped tag
when you implement a given function. Also notice that the stubbed
functions has the table name defined as their first argument, and the
default value is `__MODULE__` (`Database`). This is done to make it
easier to test the database, as it allow us to start multiple named
instances (the databases under test will get their name from the name
of the unit test they are running in, see the test implementation).

Look at the [Erlang ETS
documentation][ets-docs] for functions that
can be used to implement the module; the backing ETS table should be
defined as `:public`, so all the `:ets` function calls can be called
from the client calls.

[ets-docs]: http://erlang.org/doc/man/ets.html

A solution can be found in the `.solution` folder in the project
root. Please attempt to solve the exercise before peeking into the
solution, and instead ask your instructor for guidance if you are
lost.
