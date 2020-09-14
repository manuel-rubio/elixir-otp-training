defmodule Rpn.ApplicationTest do
  use ExUnit.Case

  test "lifecycle" do
    assert {:ok, [:rpn]} = Application.ensure_all_started(:rpn)
    assert :ok = Application.stop(:rpn)
    assert :ok = Application.unload(:rpn)
  end

  describe "retrieving dynamic supervisor information" do
    setup do
      Application.ensure_all_started(:rpn)
      :ok
      on_exit(:teardown, fn ->
        Application.stop(:rpn)
        Application.unload(:rpn)
      end)
    end

    test "get children" do
      assert [
        {:rpn3, _pid1, :worker, [Rpn]},
        {:rpn2, _pid2, :worker, [Rpn]},
        {:rpn1, _pid3, :worker, [Rpn]}
      ] = Supervisor.which_children(Rpn.Supervisor)
    end
  end
end

