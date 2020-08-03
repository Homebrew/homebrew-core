class Ultralist < Formula
  desc "Simple GTD-style task management for the command-line"
  homepage "https://ultralist.io"
  url "https://github.com/ultralist/ultralist/archive/1.2.tar.gz"
  sha256 "6681e614f9accb9e49ff3bf5a868596e1a84a4f73ca3f33de5ce6a56e3165805"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "bf0101431535e6c61e34269f05d3b1b93fdd03c4617644d99a901299c5edbb05" => :catalina
    sha256 "41f5bc28ad62eaccaa2e968d0abd0bf5e1fe5dd90967c49d4df156dcd8b1c5dd" => :mojave
    sha256 "e257c3dd6ec86db47e4b8a8444d0edb4ec212f96de2c9a762c87727a0ee668e0" => :high_sierra
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
