# Add a declarative step here for populating the DB with movies.

Given /the following movies exist/ do |movies_table|
  movies_table.hashes.each {|m| Movie.create!(m) }
end

# Make sure that one string (regexp) occurs before or after another one
#   on the same page

Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  page.body.should =~ /#{e1}.*#{e2}/m
end

# Make it easier to express checking or unchecking several boxes at once
#  "When I uncheck the following ratings: PG, G, R"
#  "When I check the following ratings: G"

When /I (un)?check the following ratings: (.*)/ do |uncheck, rating_list|
  rating_list.split(/,\s?/).each do |rating|
    step %Q{I #{uncheck}check "ratings_#{rating.gsub /"/, ''}"}
  end
end

Then /I should see all of the movies/ do
  page.should have_css('#movies tbody tr', count: Movie.all.size)
end

Then /^I should (not )?see: (.*)$/ do |no, rating_list|
  rating_list.split(/,\s?/).each do |rating|
    within('table#movies') do
      if no
        page.should_not have_content(rating)
      else
        page.should have_content(rating)
      end
    end
  end
end
