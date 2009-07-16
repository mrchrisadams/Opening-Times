module NavigationHelpers
  # Maps a name to a path. Used by the
  #
  #   When /^I go to (.+)$/ do |page_name|
  #
  # step definition in webrat_steps.rb
  #
  def path_to(page_name)
    case page_name

    when /the homepage/
      '/'
    when /^its facility page$/i
      facility_path(@facility)
    when /^the facility page for ID (\d+)$/i
      facility_path(:id => $1)
    when /^the facility page for slug "([^\"]*)"$/i
      facility_slug_path(:slug => $1)
    when /^the create a new facility page$/i
      new_facility_path
    when /^its edit_facility page$/i
      edit_facility_path(@facility)
    when /^the edit_facility page for ID (\d+)$/i
      edit_facility_path(:id => $1)
    when /^the advanced search page$/i
      url_for(:controller => 'search', :action => 'advanced')

    # Add more mappings here.
    # Here is a more fancy example:
    #
    #   when /^(.*)'s profile page$/i
    #     user_profile_path(User.find_by_login($1))

    else
      raise "Can't find mapping from \"#{page_name}\" to a path.\n" +
        "Now, go and add a mapping in #{__FILE__}"
    end
  end
end

World(NavigationHelpers)
