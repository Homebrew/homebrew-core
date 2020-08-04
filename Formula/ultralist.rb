class Ultralist < Formula
  desc "Simple GTD-style task management for the command-line"
  homepage "https://ultralist.io"
  url "https://github.com/ultralist/ultralist/archive/1.2.tar.gz"
  sha256 "6681e614f9accb9e49ff3bf5a868596e1a84a4f73ca3f33de5ce6a56e3165805"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "4f61abba8aa23b0f0f19f0c83f587e1272cf460d64853f37ffacb88781456362" => :catalina
    sha256 "bfaa61ef4c225b7b6f753aa7c25c2d4cda54c7e79aaad43cacf5e1b930951f88" => :mojave
    sha256 "f86a874044ccbd3e33f4ee60786501f09c48c46f7c45a2e91ca22497b3dc981a" => :high_sierra
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
