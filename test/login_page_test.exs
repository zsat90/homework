defmodule LoginPageTest do
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
          take_screenshot("../media/loginPageTest/failure.png")
          raise e
      end
    end
  end

  # starts the session and destroys when completed
  hound_session()

  test "Should verify everthing on the page as well as test correct login information" do
    url = "https://the-internet.herokuapp.com/login"

    navigate_to(url)

    # should verify that the the url went to the login page.
    assert_sof(visible_text({:css, "#content > div > h2"}) == "Login Page")

    # should verify the username input
    assert_sof(visible_text({:xpath, "//*[@id='login']/div[1]/div/label"}) == "Username")

    # should verify the password input
    assert_sof(visible_text({:xpath, "//*[@id='login']/div[2]/div/label"}) == "Password")

    # should verify that the login button is present
    assert_sof(find_element(:class, "radius"))

    # should fill input field with username
    fill_field({:id, "username"}, "tomsmith")

    # should fill input field with password
    fill_field({:id, "password"}, "SuperSecretPassword!")

    # should click the login button
    click({:class, "radius"})

    # give the page enough time to load elements
    :timer.sleep(1000)

    # should find the successful message after login
    find_element(:id, "flash")

    # should verify that the user is logged in
    assert_sof(visible_text({:id, "flash"}) == "You logged into a secure area!\n×")

    # should find and click on the logout button
    find_element(:xpath, "//*[@id='content']/div/a") |> click()

    # should find the username field to make sure it logged out
    assert_sof(visible_text({:xpath, "//*[@id='login']/div[1]/div/label"}) == "Username")

    # should find the password field to make sure it logged out
    assert_sof(visible_text({:xpath, "//*[@id='login']/div[2]/div/label"}) == "Password")
  end

  test "Enter in the wrong username but correct pw to make sure it stops us from logging in" do
    url = "https://the-internet.herokuapp.com/login"

    navigate_to(url)

    # should enter in the incorrect username
    fill_field({:id, "username"}, "thomassmith")

    # should enter in the correct pw
    fill_field({:id, "password"}, "SuperSecretPassword!")

    # should click the login button
    click({:class, "radius"})

    # should verify the username is invalid
    assert_sof(visible_text({:id, "flash"}) == "Your username is invalid!\n×")
  end

  test "Enter in the incorrect pw but correct username and makes sure it prevents logging in" do
    url = "https://the-internet.herokuapp.com/login"

    navigate_to(url)

    # should enter in the correct username
    fill_field({:id, "username"}, "tomsmith")

    # should enter in the incorrect pw
    fill_field({:id, "password"}, "SuperSecretPassword!!!")

    # should click the login button
    click({:class, "radius"})

    # should verify the pw is invalid
    assert_sof(visible_text({:id, "flash"}) == "Your password is invalid!\n×")
  end
end
