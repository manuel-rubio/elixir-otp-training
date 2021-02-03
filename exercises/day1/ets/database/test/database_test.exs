defmodule DatabaseTest do
  use ExUnit.Case
  doctest Database

  setup context do
    {:ok, pid} = Database.start(name: context.test)
    Map.put(context, :pid, pid)
  end

  describe "insert" do
    @tag skip: true
    test "Insert", context do
      assert :ok = Database.insert(context.test, "foo", "bar")
    end
  end

  describe "get" do
    @tag skip: true
    test "Get existing value", context do
      :ok = Database.insert(context.test, "foo", "bar")
      assert {:ok, "bar"} = Database.get(context.test, "foo")
    end

    @tag skip: true
    test "Return :not_found if there is no value for a given key", context do
      assert :not_found = Database.get(context.test, "not_there")
    end
  end

  describe "update" do
    @tag skip: true
    test "Update existing value", context do
      :ok = Database.insert(context.test, "foo", "bar")
      assert :ok = Database.update(context.test, "foo", "baz")
      assert {:ok, "baz"} = Database.get(context.test, "foo")
    end

    @tag skip: true
    test "Return :not_found if the key is non-existent", context do
      assert :not_found = Database.update(context.test, "foo", "bar")
    end
  end

  describe "delete" do
    @tag skip: true
    test "remove existing value", context do
      value = "bar"
      :ok = Database.insert(context.test, "foo", value)
      assert {:ok, ^value} = Database.get(context.test, "foo")
      assert :ok = Database.delete(context.test, "foo")
      assert :not_found = Database.get(context.test, "foo")
    end

    @tag skip: true
    test "Return :ok if there is no value for a given key", context do
      assert :ok = Database.delete(context.test, "not_there")
    end
  end
end
