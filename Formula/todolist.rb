class Todolist < Formula
  desc "Very fast, simple task manager for the command-line, based upon GTD"
  homepage "http://todolist.site"
  url "https://github.com/gammons/todolist/archive/v0.8.1.tar.gz"
  sha256 "b3eaf0a06ef212396b6b45990cf8d6a8451341b6e48d9be577bb7e457a6b4edd"

  bottle do
    cellar :any_skip_relocation
    sha256 "aa40fd0ed74a2a449935ec063459691f82fc1855e8fe2b24a1cb220a9a434baf" => :mojave
    sha256 "914d32b92a0fa0421856f0068a36f4d4b87769ec7919f05c110b124457372319" => :high_sierra
    sha256 "b3068ed4422f44173357d953a2dcc469f89f45808d7517c709558dbf26fda12f" => :sierra
    sha256 "519e69368b87773607ef70616bdf4fbd250c715f1c16bcce00e134784dd7fe24" => :el_capitan
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
