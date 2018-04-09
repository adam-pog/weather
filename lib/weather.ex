defmodule Weather do
  require Logger
  import SweetXml

  @w1_url Application.get_env(:weather, :w1_url)

  @moduledoc """
  Simple application to print weather data from w1 xml feed
  """

  @doc """
  prtins the data

  ## Examples
      iex> Weather.details
  """
  def details do
    HTTPoison.get(@w1_url)
    |> handle_response
    |> print_response
  end

  def handle_response({:ok, %{status_code: 200, body: body}}) do
    body
  end

  def handle_response({_, %{status_code: status, body: body}}) do
    Logger.error "[w1] status: #{status}, response: #{body}"
    :error
  end

  def print_response(xml_string) do
    IO.puts "weather: #{xpath(xml_string, ~x"//weather/text()")}"
    IO.puts "temp: #{xpath(xml_string, ~x"//temp_f/text()")}"
    IO.puts "wind: #{xpath(xml_string, ~x"//wind_string/text()")}"
    IO.puts "wind chill: #{xpath(xml_string, ~x"//wind_degrees/text()")}"
    IO.puts "relative humidity: #{xpath(xml_string, ~x"//relative_humidity/text()")}"
    IO.puts "updated at: #{xpath(xml_string, ~x"//observation_time/text()")}"
  end
end
