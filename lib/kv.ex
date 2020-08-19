defmodule KV.Bucket do
  @moduledoc """
  Documentation for `KV`.
  """
  use Agent

  @doc """
  Starts a new bucket
  """
  def start_link(_opts) do
    Agent.start_link(fn -> %{} end)
  end

  @doc """
  Gets a value from the `bucket` by `key`
  """
  def get(bucket, key) do
    Agent.get(bucket, &Map.get(&1, key))
  end

  @doc """
  Puts the `value` for the given `key` in the `bucket`
  """
  def put(bucket, key, value) do
    Agent.update(bucket, &Map.put(&1, key, value))
  end

  @doc """
  Deletes the `key` from the given `bucket`
  """
  def delete(bucket, key) do
    Process.sleep(1000) # puts client to sleep
    Agent.get_and_update(bucket, fn dict ->
      # When a long action is performed on the server, all other requests to that particular server will wait until the action is done, which may cause some clients to timeout.
      Process.sleep(1000) # puts server to sleep
      Map.pop(dict, key)
    end)

  end
end
