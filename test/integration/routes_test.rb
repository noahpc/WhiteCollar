require 'test_helper'

class RoutesTest < ActionDispatch::IntegrationTest
  test "test user routes" do
    assert_generates "/users", :controller => "users", :action => "index"
    assert_generates "/users/1", {:controller => "users", :action => "show", :id => "1"}
    assert_generates "/users/teacher", :controller => "users", :action => "teacher"
    assert_generates "/users/student_manager", :controller => "users", :action => "student_manager"
    assert_generates "/users/student_rep", :controller => "users", :action => "student_rep"
    assert_generates "/users/new", :controller => "users", :action => "new"
    assert_generates "/users/1/edit", {:controller => "users", :action => "edit", :id => "1"}
    assert_generates "/users", :controller => "users", :action => "create"
    assert_generates "/users/1", {:controller => "users", :action => "update", :id => "1"}
    assert_generates "/users/input_students_parse", :controller => "users", :action => "input_students_parse"
    assert_generates "/users/1", {:controller => "users", :action => "destroy", :id => "1"}
  end
  test "test client routes" do
    assert_generates "", :controller => "clients", :action => "index"
    assert_generates "/clients/1", {:controller => "clients", :action => "show", :id => "1"}
    assert_generates "/clients/new", :controller => "clients", :action => "new"
    assert_generates "/clients/1/edit", {:controller => "clients", :action => "edit", :id => "1"}
    assert_generates "/clients", :controller => "clients", :action => "create"
    assert_generates "/clients/1", {:controller => "clients", :action => "update", :id => "1"}
    assert_generates "/clients/1", {:controller => "clients", :action => "destroy", :id => "1"}
  end
  test "test project routes" do
    assert_generates "/projects", :controller => "projects", :action => "index"
    assert_generates "/projects/1", {:controller => "projects", :action => "show", :id => "1"}
    assert_generates "/projects/new", :controller => "projects", :action => "new"
    assert_generates "/projects/1/edit", {:controller => "projects", :action => "edit", :id => "1"}
    assert_generates "/projects", :controller => "projects", :action => "create"
    assert_generates "/projects/1", {:controller => "projects", :action => "update", :id => "1"}
    assert_generates "/projects/1", {:controller => "projects", :action => "destroy", :id => "1"}
  end
  test "test ticket routes" do
    assert_generates "/tickets", :controller => "tickets", :action => "index"
    assert_generates "/tickets/1", {:controller => "tickets", :action => "show", :id => "1"}
  end
end
