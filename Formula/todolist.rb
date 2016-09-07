class Todolist < Formula
  desc "Very fast, simple task manager for the command-line, based upon GTD."
  homepage "http://todolist.site"
  url "https://github.com/gammons/todolist/archive/0.3.1.tar.gz"
  sha256 "4d6587fba04e12793642df749f2c923d352c742c1409980820e6a51f6eec992f"

  bottle do
    cellar :any_skip_relocation
    sha256 "c0ef9f95fa1d682b51f71b75dc46e705c7d7f862b6ed24d55e17a9573b6a5f7d" => :el_capitan
    sha256 "c79c6abc21121073283243176aabca2560558d654bd8caed2e6bd93666755a90" => :yosemite
    sha256 "15d3e8b5304156097d843c2f4aabeb1b79f03cd67a57243a4040acaf426fb63d" => :mavericks
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
