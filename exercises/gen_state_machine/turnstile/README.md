# Turnstile

Implement a Turnstile using the GenStateMachine.

A turnstile is a door typically found at theme parks and at entry ways
to public transport systems. Usually they require a token of payment,
which will unlock them, and allow one person to enter through.

The Turnstile will have two states: "closed" (initial state) and
"open".

1. When the turnstile is in the closed state it should accept a "coin"
   as an input. Once received it should transition into the open
   state, at which point it should accept an "enter" input, that will
   transition it back into the closed state

   If the user input the enter event while the turnstile is closed
   state, they should receive an `{:error, :access_denied}` message,
   it is up to you to decide what should happen if they insert a coin
   while the turnstile is open.

2. Implement a timeout for the open state that will transition the
   turnstile back to the closed state after a given timeout has been
   reached

3. Make it possible to set a certain price needed to open the
   turnstile. It should keep track of how much money the user has
   inserted before it will transition into the open state. If the user
   insert more money than needed consider implementing a way of
   returning the money (or keep them, that implementation detail is up
   to you)

* * *

Suggested public interface:

- `start_link` -> {:ok, pid} :: start the turnstile

- `insert_coin(pid, coin)` -> :ok | ? :: insert a coin into the
  turnstile

- `enter(pid)` -> :ok | {:error, :access_denied} :: enter the
  turnstile if it is open, and respond access denied if it is closed
