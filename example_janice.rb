
thing "Signs up" do
  change do
    Browser.fill_in do |form|
      form["Name"] = "Judson"
      form["Password"] = "password"
    end.submit
  end

  expect(User).first(:username => "Judson") do
    to_not be_nil
    to be_a_kind_of(User)

    its.created_at.should be_close_to(Time.now)
  end

  expect.in(requests).one_that do
    has_path "/sign_up"
    has_body {"name" => "Judson", "password" => "password"}
    expect(its.response) do
      path == "/"
    end
  end

end

thing "Signs in" do
  precondition "example_janice", "Signs up"

  change do
    Browser.fill_in("#sign_in") do |form|
      form["Name"] = "Judson"
      form["Password"] = "password"
    end.submit
  end

  expect(User).first(:username => "Judson") do
    expect.last_sign_in.should be_close_to(Time.now)

    expect.last_sign_in.to do
      be_close_to(Time.now)
    end
  end

  expect(response) do
    expect(:body, "<html><body>Welcome, Judson!</body></html>").to do
      have_xpath("Welcome, Judson!")
    end
  end
end

#So, idea here is that this could be run (at least) two ways:
#Run "Signs in" with 'live' preconditions - so that means really running "Signs
#up" on an empty DB (and checking its expectations the first time)
#
#or
#
#Run "Signs in" with 'presupposed' preconditions.  So User is stubbed with
#first(:username => "Judson") returning a stubbed object
#
#If methods are called on stubbed objects whose value isn't defined, we can
#fall back to the 'live' version to figure out values and suggest expectations.
#(Still some programmer input because, e.g. here we probably need an encrypted
#password field for User, and the garbage that's actually in there doesn't
#help.  Context of the failing caller might help, too.
#
#Shadow mocking: what if we bring in a mock we don't want?  Because the
#precondition clause could pull any number of expected things in, we might end
#up mocking parts of the SUT without meaning to.
#
#Implication of the Shadow Mocking issue: state components aren't a whole
#depgraph - you use as preconditions all the setups that you'll need.
#
#
#What about when the SUT accesses a component of state multiple ways?  The
#state has to be able to represent a digraph of components.
#
#One way to avoid that is to say that the change and expect clauses
#
#Some syntax for representative data (for, say, lists or HTML documents that
#would be irritating to have to say "exactly like this") would be nice - above
#it's a second arg to expect ...
#
#Also, the Browser thing up there is meant as a shorthand for some Capybara
#style full-stack action.  It would be REALLY nice if there was a way to insert
#in there so that the actual requests that the browser triggers could get
#collected and used in a Webrat style test - and the responses could be used as
#mocks in the 'presumed' mode.
#
#
#
#Things missing: the result of the change block - for instance "when I create a
#thing..." the result is an important part to test.
#
#Using the change/result pair to build full-on whiny mocks.
#
#Being able to exclude tests from the spec/mock tranformation - they're tests
#within the system and shouldn't be mocked (and therefore don't require as
#rigorous testing)
