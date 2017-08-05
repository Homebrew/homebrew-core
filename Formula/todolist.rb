class Todolist < Formula
  desc "Very fast, simple task manager for the command-line, based upon GTD."
  homepage "http://todolist.site"
  url "https://github.com/gammons/todolist/archive/0.7.tar.gz"
  sha256 "3f9a3dc24b826d423a501741ce24bf7a286ea8b4a2cf7739f9731b59892c3584"

  bottle do
    cellar :any_skip_relocation
    sha256 "ce52f46de9c0a6199b8e249b81a2b7e4c721af584b6c3b9da940752d3dc6a0b2" => :sierra
    sha256 "ad92cc8acf856f2a608f2d34e93987a6dd56d7cf8b670687a327d385a3f5fcb5" => :el_capitan
    sha256 "5feccfa0c2443dba0c8cbbd42bf8cec23211e77a7661dccf663d00b92399ebe3" => :yosemite
  end

  depends_on "go" => :build
  depends_on "govendor" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/gammons/").mkpath
    ln_s buildpath, buildpath/"src/github.com/gammons/todolist"
    system "go", "build", "-o", bin/"todolist", "./src/github.com/gammons/todolist"
  end

  test do
    system bin/"todolist", "init"
    assert File.exist?(".todos.json")
    add_task = shell_output("#{bin}/todolist add learn the Tango")
    assert_match /Todo.* added/, add_task
  end
end
