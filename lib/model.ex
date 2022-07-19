defmodule Model do
  def get_file() do
    [option | data] =
      "cube.gts"
      |> File.read!()
      |> String.split("\n")

    option =
      option
      |> String.split(" ")
      |> Enum.map(fn n -> String.to_integer(n) end)

    option =
      [:vertex, :line, :triangle]
      |> Enum.zip(option)
      |> Enum.into(%{})

    data =
      Enum.map(data, fn d ->
        d
        |> String.split(" ")
        |> Enum.reject(fn c -> c == "" end)
      end)
      |> Enum.reject(fn d -> d == [] end)

    {vertex, data} = Enum.split(data, option.vertex)

    {line, triangle} = Enum.split(data, option.line)

    vertex = process_data(vertex, [:x, :y, :z])

    line = process_data(line, [:start_point, :end_point])

    triangle = process_data(triangle, [:first, :second, :third])

    cube_data = %{vertex_value: vertex, line_value: line, triangle_value: triangle}

    json_data = JSON.encode!(cube_data)

    file_name = "model.json"

    # File.write(file_name, json_data)
    File.open!(file_name, [:write])
    |> IO.binwrite(json_data)
  end

  defp process_data(values, keys) do
    Enum.map(values, fn value ->
      value = Enum.map(value, fn d -> String.to_integer(d) end)

      keys
      |> Enum.zip(value)
      |> Enum.into(%{})
    end)
  end
end
