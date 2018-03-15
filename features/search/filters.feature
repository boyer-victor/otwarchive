@users
Feature: Filters
  In order to ensure filtering works on works and bookmarks
  As a humble user
  I want to filter on a user's works and bookmarks

  Background:
    Given a canonical fandom "The Hobbit"
      And a canonical fandom "Harry Potter"
      And a canonical fandom "Legend of Korra"
      And I am logged in as "meatloaf"
      And meatloaf can use the new search
      And I post the work "A Hobbit's Meandering" with fandom "The Hobbit"
      And I post the work "Bilbo Does the Thing" with fandom "The Hobbit, Legend of Korra"
      And I post the work "Roonal Woozlib and the Ferrets of Nimh" with fandom "Harry Potter"

  @javascript
  Scenario: You can filter through a user's works using inclusion filters
    When I go to meatloaf's user page
      And I follow "Works (3)"
    Then I should see "A Hobbit's Meandering"
      And I should see "Bilbo Does the Thing"
      And I should see "Roonal Woozlib and the Ferrets of Nimh"
      And I should see "Include"
      And I should see "Exclude"
    When I press "Fandoms" within "dd.include"
    Then I should see "The Hobbit (2)" within "#include_fandom_tags"
      And I should see "Harry Potter (1)" within "#include_fandom_tags"
      And I should see "Legend of Korra (1)" within "#include_fandom_tags"
    When I check "The Hobbit (2)" within "#include_fandom_tags"
      And I press "Sort and Filter"
    Then I should see "A Hobbit's Meandering"
      And I should see "Bilbo Does the Thing"
      And I should not see "Roonal Woozlib and the Ferrets of Nimh"
    When I press "Fandoms" within "dd.include"
    Then I should see "The Hobbit (2)" within "#include_fandom_tags"
      And I should see "Legend of Korra (1)" within "#include_fandom_tags"
      And I should not see "Harry Potter (1)" within "#include_fandom_tags"
    When I check "Legend of Korra (1)" within "#include_fandom_tags"
      And press "Sort and Filter"
    Then I should see "Bilbo Does the Thing"
      And I should not see "A Hobbit's Meandering"
      And I should not see "Roonal Woozlib and the Ferrets of Nimh"
    When I press "Fandoms" within "dd.include"
      And I uncheck "The Hobbit (1)" within "#include_fandom_tags"
      And I uncheck "Legend of Korra (1)" within "#include_fandom_tags"
      And I press "Sort and Filter"
    Then I should see "Roonal Woozlib and the Ferrets of Nimh"
      And I should see "A Hobbit's Meandering"
      And I should see "Bilbo Does the Thing"

  @javascript
  Scenario: You can filter through a user's works using exclusion filters
    When I go to meatloaf's user page
      And I follow "Works (3)"
    When I press "Fandoms" within "dd.exclude"
    Then I should see "The Hobbit (2)" within "#exclude_fandom_tags"
      And I should see "Harry Potter (1)" within "#exclude_fandom_tags"
      And I should see "Legend of Korra (1)" within "#exclude_fandom_tags"
    When I check "Harry Potter (1)" within "#exclude_fandom_tags"
      And I press "Sort and Filter"
    Then I should see "Bilbo Does the Thing"
      And I should see "A Hobbit's Meandering"
      And I should not see "Roonal Woozlib and the Ferrets of Nimh"
    When I press "Fandoms" within "dd.exclude"
    Then I should see "The Hobbit (2)" within "#exclude_fandom_tags"
      And I should see "Legend of Korra (1)" within "#exclude_fandom_tags"
      And I should see "Harry Potter (0)" within "#exclude_fandom_tags"
    When I check "Legend of Korra (1)" within "#exclude_fandom_tags"
      And I press "Sort and Filter"
    Then I should see "A Hobbit's Meandering"
      And I should not see "Bilbo Does the Thing"
      And I should not see "Roonal Woozlib and the Ferrets of Nimh"

  @javascript
  Scenario: You can filter through a user's bookmarks using inclusion filters
    Given I am logged in as "recengine"
      And recengine can use the new search
      And I bookmark the work "Bilbo Does the Thing"
      And I bookmark the work "A Hobbit's Meandering"
      And I bookmark the work "Roonal Woozlib and the Ferrets of Nimh"
    When I go to recengine's user page
      And I follow "Bookmarks (3)"
    Then I should see "Bilbo Does the Thing"
      And I should see "A Hobbit's Meandering"
      And I should see "Roonal Woozlib and the Ferrets of Nimh"
      And I should see "Include"
      And I should see "Exclude"
    When I press "Fandoms" within "dd.include"
    Then I should see "The Hobbit (2)" within "#include_fandom_tags"
      And I should see "Harry Potter (1)" within "#include_fandom_tags"
      And I should see "Legend of Korra (1)" within "#include_fandom_tags"
    When I check "The Hobbit (2)" within "#include_fandom_tags"
      And I press "Sort and Filter"
    Then I should see "A Hobbit's Meandering"
      And I should see "Bilbo Does the Thing"
      And I should not see "Roonal Woozlib and the Ferrets of Nimh"
    When I press "Fandoms" within "dd.include"
    Then I should see "The Hobbit (2)" within "#include_fandom_tags"
      And I should see "Legend of Korra (1)" within "#include_fandom_tags"
      And I should not see "Harry Potter (1)" within "#include_fandom_tags"
    When I check "Legend of Korra (1)" within "#include_fandom_tags"
      And press "Sort and Filter"
    Then I should see "Bilbo Does the Thing"
      And I should not see "A Hobbit's Meandering"
      And I should not see "Roonal Woozlib and the Ferrets of Nimh"

  @javascript
  Scenario: You can filter through a user's bookmarks using exclusion filters
    Given I am logged in as "recengine"
      And recengine can use the new search
      And I bookmark the work "Bilbo Does the Thing"
      And I bookmark the work "A Hobbit's Meandering"
      And I bookmark the work "Roonal Woozlib and the Ferrets of Nimh"
    When I go to recengine's user page
      And I follow "Bookmarks (3)"
    When I press "Fandoms" within "dd.exclude"
    Then the "The Hobbit (2)" checkbox within "#exclude_fandom_tags" should not be checked
      And the "Harry Potter (1)" checkbox within "#exclude_fandom_tags" should not be checked
      And the "Legend of Korra (1)" checkbox within "#exclude_fandom_tags" should not be checked
    When I check "Harry Potter (1)" within "#exclude_fandom_tags"
      And I press "Sort and Filter"
    Then I should see "Bilbo Does the Thing"
      And I should see "A Hobbit's Meandering"
      And I should not see "Roonal Woozlib and the Ferrets of Nimh"
    When I press "Fandoms" within "dd.exclude"
    Then the "The Hobbit (2)" checkbox within "#exclude_fandom_tags" should not be checked
      And the "Legend of Korra (1)" checkbox within "#exclude_fandom_tags" should not be checked
      And the "Harry Potter (0)" checkbox within "#exclude_fandom_tags" should be checked
    When I check "Legend of Korra (1)" within "#exclude_fandom_tags"
      And I press "Sort and Filter"
    Then I should see "A Hobbit's Meandering"
      And I should not see "Bilbo Does the Thing"
      And I should not see "Roonal Woozlib and the Ferrets of Nimh"

  @javascript
  Scenario: Filter a user's bookmarks by bookmarker's tags
    Given I am logged in as "recengine"
      And recengine can use the new search
      And I bookmark the work "Bilbo Does the Thing" with the tags "to read,been here"
      And I bookmark the work "A Hobbit's Meandering" with the tags "to read"
      And I bookmark the work "Roonal Woozlib and the Ferrets of Nimh" with the tags "been here"

    # Use an include checkbox
    When I go to my bookmarks page
      And I press "Bookmarker's Tags" within "dd.include"
    Then the "to read (2)" checkbox within "#include_tag_tags" should not be checked
      And the "been here (2)" checkbox within "#include_tag_tags" should not be checked
    When I check "to read (2)" within "#include_tag_tags"
      And I press "Sort and Filter"
    Then I should see "2 Bookmarks by recengine"
      And the "to read (2)" checkbox within "#include_tag_tags" should be checked
      And I should see "Bilbo Does the Thing"
      And I should see "A Hobbit's Meandering"
      And I should not see "Roonal Woozlib and the Ferrets of Nimh"

    # Use a second include checkbox for bookmarks with both tags
    When I check "been here (1)" within "#include_tag_tags"
      And I press "Sort and Filter"
    Then I should see "1 Bookmark by recengine"
      And I should see "Bilbo Does the Thing"

    # Use an exclude checkbox
    When I go to my bookmarks page
      And I press "Bookmarker's Tags" within "dd.exclude"
    Then the "to read (2)" checkbox within "#exclude_tag_tags" should not be checked
      And the "been here (2)" checkbox within "#exclude_tag_tags" should not be checked
    When I check "to read (2)" within "#exclude_tag_tags"
      And I press "Sort and Filter"
    Then I should see "1 Bookmark by recengine"
      And the "to read (0)" checkbox within "#exclude_tag_tags" should be checked
      And I should not see "Bilbo Does the Thing"
      And I should not see "A Hobbit's Meandering"
      And I should see "Roonal Woozlib and the Ferrets of Nimh"

    # Use a second exclude checkbox for bookmarks with neither tags
    When I check "been here (1)" within "#exclude_tag_tags"
      And I press "Sort and Filter"
    Then I should see "0 Bookmarks by recengine"

    # Use include field
    When I go to my bookmarks page
      And I fill in "Other bookmarker's tags to include" with "to read"
      And I press "Sort and Filter"
    Then I should see "2 Bookmarks by recengine"
      And I should see "Bilbo Does the Thing"
      And I should see "A Hobbit's Meandering"
      And I should not see "Roonal Woozlib and the Ferrets of Nimh"

    # Use exclude field
    When I go to my bookmarks page
      And I fill in "Other bookmarker's tags to exclude" with "to read"
      And I press "Sort and Filter"
    Then I should see "1 Bookmark by recengine"
      And I should not see "Bilbo Does the Thing"
      And I should not see "A Hobbit's Meandering"
      And I should see "Roonal Woozlib and the Ferrets of Nimh"

  @javascript @old-search
  Scenario: The filter counts should match the actual returned count
    Given I am logged in as "meatloaf"
      And I bookmark the work "Bilbo Does the Thing"
      And I bookmark the work "A Hobbit's Meandering"
      And I am logged out
      And I am logged in as "anothermeatloaf"
      And I bookmark the work "Bilbo Does the Thing"
      And I bookmark the work "A Hobbit's Meandering"
      And all indexing jobs have been run
    When I go to the bookmarks tagged "The Hobbit"
    Then I should see "4 Bookmarks in The Hobbit"
    When I follow "Fandoms"
    Then I should see "The Hobbit (4)"

  @javascript @new-search
  Scenario: Tag bookmark pages should display bookmarked items instead of bookmarks, and the sidebar counts should reflect that.
    Given I am logged in as "meatloaf"
      And I bookmark the work "Bilbo Does the Thing"
      And I bookmark the work "A Hobbit's Meandering"
      And I am logged out
      And I am logged in as "anothermeatloaf"
      And I bookmark the work "Bilbo Does the Thing"
      And I bookmark the work "A Hobbit's Meandering"
      And all indexing jobs have been run
    When I go to the bookmarks tagged "The Hobbit"
    Then I should see "2 Bookmarked Items in The Hobbit"
    When I follow "Fandoms"
    Then I should see "The Hobbit (2)"