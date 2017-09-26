class Todolist < Formula
  desc "Very fast, simple task manager for the command-line, based upon GTD."
  homepage "http://todolist.site"
  url "https://github.com/gammons/todolist/archive/0.8.tar.gz"
  sha256 "3c70dfb5e331cc636bd22fc686223faa34459a1b5e18d6b53557a14dff7a2b23"

  bottle do
    cellar :any
    sha256 "0e34e278656d5ac75827b04208bd0ec062ee43210bef7bb410bf7e8842627f5c" => :high_sierra
    sha256 "78e2fa559f361af84f01d9c62fe4ea36b88295434eceacada998682715d16364" => :sierra
    sha256 "ec0c30b9ec9df525fe5026e0724e6c1164231046f4a5d0c0ffb5361cceed323f" => :el_capitan
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
