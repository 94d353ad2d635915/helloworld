require "application_system_test_case"

class EventlogsTest < ApplicationSystemTestCase
  setup do
    @eventlog = eventlogs(:one)
  end

  test "visiting the index" do
    visit eventlogs_url
    assert_selector "h1", text: "Eventlogs"
  end

  test "creating a Eventlog" do
    visit eventlogs_url
    click_on "New Eventlog"

    fill_in "Create At", with: @eventlog.create_at
    fill_in "Description", with: @eventlog.description
    fill_in "Event", with: @eventlog.event_id
    fill_in "User Agent", with: @eventlog.user_agent
    fill_in "User", with: @eventlog.user_id
    click_on "Create Eventlog"

    assert_text "Eventlog was successfully created"
    click_on "Back"
  end

  test "updating a Eventlog" do
    visit eventlogs_url
    click_on "Edit", match: :first

    fill_in "Create At", with: @eventlog.create_at
    fill_in "Description", with: @eventlog.description
    fill_in "Event", with: @eventlog.event_id
    fill_in "User Agent", with: @eventlog.user_agent
    fill_in "User", with: @eventlog.user_id
    click_on "Update Eventlog"

    assert_text "Eventlog was successfully updated"
    click_on "Back"
  end

  test "destroying a Eventlog" do
    visit eventlogs_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Eventlog was successfully destroyed"
  end
end
