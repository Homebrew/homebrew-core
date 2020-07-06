class Ultralist < Formula
  desc "Simple GTD-style task management for the command-line"
  homepage "https://ultralist.io"
  url "https://github.com/ultralist/ultralist/archive/0.9.7.tar.gz"
  sha256 "cfc5740c717eca2410cfbd3c77c03ffd33f7e4f828ecef924c2f6c4b6e73dba9"

  bottle do
    cellar :any_skip_relocation
    sha256 "d4200e85acf5aab3d023c07a6237c48919d8410beceee83e1fb83f022d914425" => :catalina
    sha256 "218dd99addf3829f208d0c4705dd331b1cc3be224812938c7c2f5065c27fc011" => :mojave
    sha256 "9a641de380de1f1f58a60d58d7ed42246ce56254636a4d8639e105c87113dab0" => :high_sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/ultralist/").mkpath
    ln_s buildpath, buildpath/"src/github.com/ultralist/ultralist"
    system "go", "build", "-o", bin/"ultralist", "./src/github.com/ultralist/ultralist"
  end

  test do
    system bin/"ultralist", "init"
    assert_predicate testpath/".todos.json", :exist?
    add_task = shell_output("#{bin}/ultralist add learn the Tango")
    assert_match /Todo.* added/, add_task
  end
end
