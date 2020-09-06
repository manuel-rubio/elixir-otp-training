# KeyValue

Implement a key value store using a GenServer.

The public interface should have the following interface:

- `start()` -> `{:ok, pid}` :: Start the GenServer process holding the
  key-value store
- `stop(pid)` -> `:ok` :: Stop the GenServer process
- `insert(pid, key, value)` -> `:ok` | `{:error, :already_exist}` ::
     Insert the given value under the given key, but fail if there is
     already a value stored under the given key
- `get(pid, key)` -> `{:ok, value}` | `:not_found` :: Return the value
     stored under the given key; or return a not found if the key is
     non existent in the data store
- `update(pid, key, value)` -> `:ok` | `:not_found` :: Overwrite the
     value stored under key
- `delete(pid, key)` -> `:ok` :: Remove the key and its value from the
  data store
