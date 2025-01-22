class Task2dot < Formula
  include Language::Python::Virtualenv

  desc "Convert taskwarrior export to graphviz format"
  homepage "https://github.com/garykl/task2dot"
  url "https://github.com/matteoquintiliani/task2dot/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "8accb865a24d8cfcfd79071cfba261fa7813614057bc20b92028214e4a7049c9"
  license "GPL-3.0-or-later"

  depends_on "graphviz"
  depends_on "python@3.13"
  depends_on "task"

  def install
    virtualenv_install_with_resources
  end

  test do
    test_json = <<~JSON
      [{
        "id":26,
        "description":"Test task2dot",
        "entry":"20250121T132816Z",
       "modified":"20250121T132816Z",
        "project":"task2dot",
        "status":"pending",
        "uuid":"5bebfac9-3a3b-451d-8ef5-64c722fbf0f3",
        "urgency":1
        }]
    JSON
    (testpath/".taskrc").write ""
    test_out = pipe_output(bin/"task2dot", test_json)
    assert_match "Test task2dot", test_out
  end
end
