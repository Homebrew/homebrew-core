class Todolist < Formula
  desc "Very fast, simple task manager for the command-line, based upon GTD."
  homepage "http://todolist.site"
  url "https://github.com/gammons/todolist/archive/0.3.1.tar.gz"
  sha256 "4d6587fba04e12793642df749f2c923d352c742c1409980820e6a51f6eec992f"

  bottle do
    cellar :any_skip_relocation
    sha256 "e1a3cadb2e5a0ff2611f412b178a6d8100ea5b6b11b5eef22887a1e6b5e5d65a" => :sierra
    sha256 "0d8ee858df2f5094f4c3af57601f22f421e4c961820d990e5db514ce3a3eac8c" => :el_capitan
    sha256 "ce7ce6b364e99a892b752ae826ebf297a8c4abae9957840ebe3be5589da79a13" => :yosemite
    sha256 "7e735a688bad9d8b7c3e3fcee830bdcc94c65c74906c0825ee7843fd36f42f65" => :mavericks
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
