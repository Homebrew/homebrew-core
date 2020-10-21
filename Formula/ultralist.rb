class Ultralist < Formula
  desc "Simple GTD-style task management for the command-line"
  homepage "https://ultralist.io"
  url "https://github.com/ultralist/ultralist/archive/1.6.tar.gz"
  sha256 "1fceec81e9647aa7798e48e5bdd41367423cb8a0932a234eacbb95a3679997ed"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "2828c950bc75fa8f0c9bd67278f15f3f1633d370db2d7233390110994c89a7a1" => :catalina
    sha256 "bead29cbceca84cd47b603dfe65f2107d84703d8b194b44e70389fa484d4a9a6" => :mojave
    sha256 "c7c0a74cc6d362cdd39072134076dbf622e65a8a6721b97007e731397080f935" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args
  end

  test do
    system bin/"ultralist", "init"
    assert_predicate testpath/".todos.json", :exist?
    add_task = shell_output("#{bin}/ultralist add learn the Tango")
    assert_match /Todo.* added/, add_task
  end
end
