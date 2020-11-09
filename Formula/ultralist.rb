class Ultralist < Formula
  desc "Simple GTD-style task management for the command-line"
  homepage "https://ultralist.io"
  url "https://github.com/ultralist/ultralist/archive/1.6.3.tar.gz"
  sha256 "8bb36f26e24dd38df37d70bfc5585af10f6749a8c6e6c33a4f6cefa13524fa9a"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "710b0d878bb9cf37dc04377183bded8c642e59bec10fea3af9db5efbe1ae5332" => :catalina
    sha256 "7fa1b461c3816ae4357bb6bf3b46c4b0d36a467869a1a3b11839fafb956d6e9b" => :mojave
    sha256 "347033ae2ad577f8ce7f1ad948d00f0b1adf5ca056a66affc6512add7ccca96d" => :high_sierra
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
