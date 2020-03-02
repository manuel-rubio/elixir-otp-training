# Cache

Implement a cache with two layers of generations.

Our cache will have two ETS tables; When an element is requested from
the resource we will:

- Ask the ETS table that is marked as the current generation, and
  serve the response from here if it exist
- If it didn't exist in the first layer we will ask the ETS table
  marked as the old generation; if found we will send this as a
  response to the client, and copy it to the current generation
- If found in neither the current or old generation we will ask the
  resource for the value, and cache the value in the current
  generation

On an interval we will start a new generation; when this happens we
will delete the ETS table storing the old generation and make the
current ETS table the "old generation", moving it down one layer.

A resource that mock some heavy work is provided in the application.
