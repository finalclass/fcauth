defimpl Jason.Encoder, for: FCAuth.User do
  def encode(value, opts) do
    Jason.Encode.map(Map.from_struct(value), opts)
  end
end
