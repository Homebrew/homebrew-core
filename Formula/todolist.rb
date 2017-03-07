class Todolist < Formula
  desc "Very fast, simple task manager for the command-line, based upon GTD."
  homepage "http://todolist.site"
  url "https://github.com/gammons/todolist/archive/0.5.1.tar.gz"
  sha256 "c7eff52b380a7e8287fceb049be9eca88fe1214598d4764f183a2fef469e5ae9"

  bottle do
    cellar :any_skip_relocation
    sha256 "0cb29a453110be80800d81185fd1b73f0f8507c18a7ffa8947e37fd5cf50ee8d" => :sierra
    sha256 "653b9e1105d4f45c329cdb931d13452323d54cb4994e02fc2db48f9e4ea7bc23" => :el_capitan
    sha256 "00e2c661bf38a93f7d6e3642ae59444557140b3644216262af80364fc957204a" => :yosemite
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
