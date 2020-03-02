# Mutex

Write a process that will act as a binary semaphore providing mutual
exclusion (mutex) for processes that want to share a resource. Model
your process as a finite state machine with two states, busy and
free. If a process tries to take the mutex (by calling `Mutex.wait()`)
when the process is in state busy, the function call should hang until
the mutex becomes available (namely, the process holding the mutex
calls `Mutex.signal()`).
