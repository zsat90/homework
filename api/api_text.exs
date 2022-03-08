# Started to write the request for API testing
defmodule APITesting do
  HTTPoison.get!("https://reqres.in/api/login")

  %HTTPoison.Response{
    status_code: 200,
    headers: [{"content-type", "application/json"}],
    body: "{...}"
  }
end
