defmodule InputTest do
  # import helpers
  use Hound.Helpers
  use ExUnit.Case

  # assert screenshot on failure
  defmacro assert_sof(assertion) do
    quote do
      try do
        assert unquote(assertion)
      rescue
        e ->
          take_screenshot("../media/inputTest/failure.png")
          raise e
      end
    end
  end

  # starts the session and destroys when completed
  hound_session()

  test "Should verify all elements on the page" do
    url = "https://the-internet.herokuapp.com/inputs"

    navigate_to(url)

    # should verify inputs header
    assert_sof(visible_text({:xpath, "//*[@id='content']/div/div/h3"}) == "Inputs")

    # should verify the header above input field
    assert_sof(visible_text({:class, "example"}) == "Number")

    # finds the input field element
    find_element(:xpath, "//*[@id='content']/div/div/div/input")
  end

  test "Should verify the numbers entered into the input field" do
    url = "https://the-internet.herokuapp.com/inputs"

    navigate_to(url)

    # finds the input field element and clicks
    find_element(:xpath, "//*[@id='content']/div/div/div/input") |> click()

    # should fill the input box with 5
    fill_field({:xpath, "//*[@id='content']/div/div/div/input"}, "5")

    # should find the input field and set it to a variable called element
    element = find_element(:xpath, "//*[@id='content']/div/div/div/input")

    # should verify that the number entered is 5
    assert_sof(attribute_value(element, "value") == "5")

    # finds the input field element and clicks
    find_element(:xpath, "//*[@id='content']/div/div/div/input") |> click()

    # should click the up key increasing the number by 1
    send_keys(:up_arrow)

    # should verify the number was changed to 6
    assert_sof(attribute_value(element, "value") == "6")

    # should click the down arrow key 2 times
    send_keys(:down_arrow)

    send_keys(:down_arrow)

    # should verify the input value is 4
    assert_sof(attribute_value(element, "value") == "4")

    # should try and enter text into the input field
    fill_field({:xpath, "//*[@id='content']/div/div/div/input"}, "Hello")

    # should verify that the input field is blank
    assert_sof(attribute_value(element, "value") == "")
  end
end
