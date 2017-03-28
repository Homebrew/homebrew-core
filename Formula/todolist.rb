class Todolist < Formula
  desc "Very fast, simple task manager for the command-line, based upon GTD."
  homepage "http://todolist.site"
  url "https://github.com/gammons/todolist/archive/0.5.2.tar.gz"
  sha256 "915b3284fd4ace4d22486ce9a2662d11e63b21f13238437d49a6102c8a9b4c77"

  bottle do
    cellar :any_skip_relocation
    sha256 "33099c6f8e272f1cfe3f96b526764f5067975b84b01b1e147768ce3f3bd72a09" => :sierra
    sha256 "0093cef065ef3e1b99b8302c1ee30828bd2206e76cf35a568f8e2c8c4446b4fa" => :el_capitan
    sha256 "0fe2e016558570648c38c4da676857e436bc459fc30d29045838705a2d06c3d5" => :yosemite
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
    assert_match "Todo added", add_task
  end
end
