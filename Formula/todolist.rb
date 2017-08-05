class Todolist < Formula
  desc "Very fast, simple task manager for the command-line, based upon GTD."
  homepage "http://todolist.site"
  url "https://github.com/gammons/todolist/archive/0.7.tar.gz"
  sha256 "3f9a3dc24b826d423a501741ce24bf7a286ea8b4a2cf7739f9731b59892c3584"

  bottle do
    cellar :any_skip_relocation
    sha256 "25d9f94a89c3dfd7f79e3d514520af2ec58a6c1f00e99044a645506fff6339f2" => :sierra
    sha256 "81871d291a1308aa114f91b743296a7977e513acbac3438f40e588c07db93b98" => :el_capitan
    sha256 "0ff408ff109b12f7d7fdca055f9d0c3bb6db8f964e1a5e368b8f2e9fd5f12245" => :yosemite
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
