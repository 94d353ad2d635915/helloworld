require "application_system_test_case"

class CreditlogsTest < ApplicationSystemTestCase
  setup do
    @creditlog = creditlogs(:one)
  end

  test "visiting the index" do
    visit creditlogs_url
    assert_selector "h1", text: "Creditlogs"
  end

  test "creating a Creditlog" do
    visit creditlogs_url
    click_on "New Creditlog"

    fill_in "Amount", with: @creditlog.amount
    fill_in "Balance", with: @creditlog.balance
    fill_in "Currency", with: @creditlog.currency
    fill_in "Event", with: @creditlog.event_id
    click_on "Create Creditlog"

    assert_text "Creditlog was successfully created"
    click_on "Back"
  end

  test "updating a Creditlog" do
    visit creditlogs_url
    click_on "Edit", match: :first

    fill_in "Amount", with: @creditlog.amount
    fill_in "Balance", with: @creditlog.balance
    fill_in "Currency", with: @creditlog.currency
    fill_in "Event", with: @creditlog.event_id
    click_on "Update Creditlog"

    assert_text "Creditlog was successfully updated"
    click_on "Back"
  end

  test "destroying a Creditlog" do
    visit creditlogs_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Creditlog was successfully destroyed"
  end
end
