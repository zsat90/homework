defmodule DropDownTest do
  # import helpers
  use Hound.Helpers
  use ExUnit.Case

  # starts the session and destroys when completed
  hound_session()

  test "should get visible text of Header and dropdown" do
    navigate_to("https://the-internet.herokuapp.com/dropdown")

    # should make sure the header is visible
    assert visible_text({:tag, "h3"}) == "Dropdown List"

    # should make sure the dropdown is displayed
    assert element_displayed?({:id, "dropdown"})

    # should click on dropdown
    click({:id, "dropdown"})

    # should find and click on option 1
    find_element(:css, "#dropdown > option:nth-child(2)") |> click()

    # take_screenshot("../media/dropdownTest/option1.png")

    # should verify that Option 1 is now visible in the dropdown
    assert visible_text({:css, "#dropdown > option:nth-child(2)"}) == "Option 1"

    # should click on the dropdown
    click({:id, "dropdown"})

    # should click on option 2
    find_element(:css, "#dropdown > option:nth-child(3)") |> click()

    # take_screenshot("../media/dropdownTest/option2.png")

    # should verify that option 2 is now visible in dropdown
    assert visible_text({:css, "#dropdown > option:nth-child(3)"}) == "Option 2"

    refresh_page()

    # should verify that the option list was reset after page refresh
    assert visible_text({:css, "#dropdown > option:nth-child(1)"}) == "Please select an option"
  end
end
