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
    # replace with your own implementation
    Enum.count(list)
  end

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
  @spec member?(list, any()) :: Boolean
  def member?(haystack, needle) do
    # replace with your own implementation
    Enum.member?(haystack, needle)
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
    # replace with your own implementation
    Enum.min(haystack)
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
    # replace with your own implementation
    Enum.reverse(list)
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
    # replace with your own implementation
    Enum.filter(list, fun)
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
  @spec dedup(list) :: [Any]
  def dedup(list) do
    # replace with your own implementation
    Enum.dedup(list)
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
  def chunk_every(list, n) do
    # replace with your own implementation
    Enum.chunk_every(list, n)
  end
end
