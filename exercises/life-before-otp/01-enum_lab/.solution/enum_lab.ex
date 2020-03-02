defmodule EnumLab do
  @moduledoc """
  In this exercise we will reimplement parts of the Enum module. We
  will restrict the functions we are allowed to use, so please don't
  use the functions found in other modules from the Elixir standard
  library; list comprehensions are also off limites.
  """

  @doc """
  Reimplement the functionality of `Enum.count/1` without using the
  `count/1` function from the `Enum`-module.

      iex> EnumLab.count([])
      0
      iex> EnumLab.count([1])
      1
      iex> EnumLab.count([1, 2, 3, 4])
      4

  """
  @spec count(list) :: [any()]
  def count(list) do
    do_count(list, 0)
  end

  defp do_count([], acc), do: acc
  defp do_count([_ | rest], acc), do: do_count(rest, acc + 1)

  @doc """
  Reimplement the functionality of `Enum.member?/1` without using the
  `member?/1` function from the `Enum`-module.

      iex> EnumLab.member?([], 5)
      false
      iex> EnumLab.member?([1], 1)
      true
      iex> EnumLab.member?([1, 2, 3, 4], 3)
      true
      iex> EnumLab.member?([1, 2, 3, 4], 7)
      false

  """
  @spec member?(list(any), any()) :: Boolean
  def member?([], _) do
    false
  end

  def member?([same | _haystack], same) do
    true
  end

  def member?([_ | haystack], needle) do
    member?(haystack, needle)
  end

  @doc """
  Reimplement the functionality of `Enum.min/1` without using the
  `min/1` function from the `Enum`-module.

      iex> EnumLab.min([1, 2, 3, 4])
      1
      iex> EnumLab.min([4, 3, 2, 1])
      1
      iex> EnumLab.min([5, 42, 3, 108, 3])
      3

  Notice that an empty list given to the Enum.min function will raise
  an "empty error.", feel free to replicate this behavior, or return
  nil if an empty list is passed in.
  """
  @spec min([Integer]) :: Integer | nil
  def min(haystack) do
    do_min(haystack, nil)
  end

  defp do_min([], current), do: current

  defp do_min([head | rest], current) when current > head do
    do_min(rest, head)
  end

  defp do_min([_ | rest], current) do
    do_min(rest, current)
  end

  @doc """
  Reimplement the functionality of `Enum.reverse/1` without using the
  `reverse/1` function from the `Enum`-module.

      iex> EnumLab.reverse([1, 2, 3, 4])
      [4, 3, 2, 1]
      iex> EnumLab.reverse([1, 1, 2, 2])
      [2, 2, 1, 1]
      iex> EnumLab.reverse([1, 2, 1])
      [1, 2, 1]

  """
  @spec reverse(list) :: [Any]
  def reverse(list) do
    do_reverse(list, [])
  end

  defp do_reverse([], acc) do
    acc
  end

  defp do_reverse([head | rest], acc) do
    do_reverse(rest, [head | acc])
  end

  @doc """
  Reimplement the functionality of `Enum.filter/2` without using the
  `filter/2` function from the `Enum`-module.

      iex> EnumLab.filter([1, 2, 3, 4], fn x -> x < 3 end)
      [1, 2]
      iex> EnumLab.filter([1, 1, 2, 2], fn x -> x == 1 end)
      [1, 1]
      iex> EnumLab.filter([1, 2, 3, 4, 5, 6], fn x -> rem(x, 2) == 1 end)
      [1, 3, 5]

  """
  @spec filter(list, function) :: [Any]
  def filter(list, fun) do
    do_filter(list, [], fun)
  end

  defp do_filter([], acc, _) do
    reverse(acc)
  end

  defp do_filter([head | rest], acc, fun) do
    if (fun.(head)) do
      do_filter(rest, [head | acc], fun)
    else
      do_filter(rest, acc, fun)
    end
  end

  @doc """
  Reimplement the functionality of `Enum.dedup/1` without using the
  `dedup/1` function from the `Enum`-module.

      iex> EnumLab.dedup([])
      []
      iex> EnumLab.dedup([1, 2, 3, 4])
      [1, 2, 3, 4]
      iex> EnumLab.dedup([1, 1, 2, 2])
      [1, 2]
      iex> EnumLab.dedup([1, 1, 2, 2, 1, 1])
      [1, 2, 1]

  """
  @spec dedup(list(Any)) :: [Any]
  def dedup([]) do
    []
  end

  def dedup([head | rest]) do
    do_dedup(rest, [head])
  end

  defp do_dedup([], acc) do
    reverse(acc)
  end

  defp do_dedup([same | rest], [same | _] = acc) do
    do_dedup(rest, acc)
  end

  defp do_dedup([current | rest], acc) do
    do_dedup(rest, [current | acc])
  end

  @doc """
  Reimplement the functionality of `Enum.chunk_every/2` without using
  the `chunk_every/2` function from the `Enum`-module.

      iex> EnumLab.chunk_every([1, 2, 3, 4], 2)
      [[1, 2], [3, 4]]
      iex> EnumLab.chunk_every([4, 3, 2, 1], 2)
      [[4, 3], [2, 1]]
      iex> EnumLab.chunk_every([5, 42, 3, 108], 3)
      [[5, 42, 3], [108]]

  """
  @spec chunk_every(list(Any), pos_integer) :: [list]
  def chunk_every(list, count) when count > 0 do
    do_chunk_every(list, count, {[], count}, [])
  end

  # base cases
  defp do_chunk_every([], _n, {[], 0}, acc) do
    reverse(acc)
  end

  defp do_chunk_every([], n, {cur_acc, _cur_n}, acc) do
    do_chunk_every([], n, {[], 0}, [reverse(cur_acc) | acc])
  end

  # inner base case
  defp do_chunk_every(rest, n, {cur_acc, 0}, acc) do
    do_chunk_every(rest, n, {[], n}, [reverse(cur_acc) | acc])
  end

  # recursive case
  defp do_chunk_every([head | rest], n, {cur_acc, cur_n}, acc) do
    do_chunk_every(rest, n, {[head | cur_acc], cur_n - 1}, acc)
  end
end
