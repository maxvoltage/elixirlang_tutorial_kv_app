defmodule KV.RegistryETSTest do
  use ExUnit.Case, async: true

  setup context do
    start_supervised!({KV.RegistryETS, name: context.test}) 
    %{registry: context.test}
  end

  test "spawns buckets", %{registry: registry} do
    assert KV.RegistryETS.lookup(registry, "shopping") == :error

    KV.RegistryETS.create(registry, "shopping")
    assert {:ok, bucket} = KV.RegistryETS.lookup(registry, "shopping")

    KV.Bucket.put(bucket, "milk", 1)
    assert KV.Bucket.get(bucket, "milk") == 1
  end

  test "removes buckets on exit", %{registry: registry} do
    KV.RegistryETS.create(registry, "shopping")
    {:ok, bucket} = KV.RegistryETS.lookup(registry, "shopping")
    Agent.stop(bucket, :shutdown)
    assert KV.RegistryETS.lookup(registry, "shopping") == :error
  end
end
