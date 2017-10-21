class Todolist < Formula
  desc "Very fast, simple task manager for the command-line, based upon GTD."
  homepage "http://todolist.site"
  url "https://github.com/gammons/todolist/archive/0.8.tar.gz"
  sha256 "3c70dfb5e331cc636bd22fc686223faa34459a1b5e18d6b53557a14dff7a2b23"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "3b4b8d23cb5b1fd8dd1bad37cf27688ec151d3e79e3b593e0ed49b5c7511a8a7" => :high_sierra
    sha256 "8aeeaa40bf1a97facb75fc2f559c0f5534b576061758476ea5538e32be3000fe" => :sierra
    sha256 "80d0eac56e379fea4c651cc9e38ae07dac6bfd3464b7b31153a47c74da9b35cb" => :el_capitan
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
    assert_predicate testpath/".todos.json", :exist?
    add_task = shell_output("#{bin}/todolist add learn the Tango")
    assert_match /Todo.* added/, add_task
  end
end
