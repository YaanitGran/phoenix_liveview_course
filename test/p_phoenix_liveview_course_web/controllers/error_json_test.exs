defmodule PPhoenixLiveviewCourseWeb.ErrorJSONTest do
  use PPhoenixLiveviewCourseWeb.ConnCase, async: true

  test "renders 404" do
    assert PPhoenixLiveviewCourseWeb.ErrorJSON.render("404.json", %{}) == %{errors: %{detail: "Not Found"}}
  end

  test "renders 500" do
    assert PPhoenixLiveviewCourseWeb.ErrorJSON.render("500.json", %{}) ==
             %{errors: %{detail: "Internal Server Error"}}
  end
end
