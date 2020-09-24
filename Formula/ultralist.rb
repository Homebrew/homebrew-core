class Ultralist < Formula
  desc "Simple GTD-style task management for the command-line"
  homepage "https://ultralist.io"
  url "https://github.com/ultralist/ultralist/archive/1.5.1.tar.gz"
  sha256 "85c15c096fbc8e6f2728783f7243aea0810a0e93e00558efa48473d220459069"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "18c8a9e0c9b75a31d797f89953c064ab7853285d424bea88bc0df46454c080df" => :catalina
    sha256 "8629115e0ea5a89613892e30c7cabfea7d68dd7a93d0f08360640cb72e91ef10" => :mojave
    sha256 "780af9c7c8acd4957d12c666a430e4a47e77ed216567c339579b31098aec113d" => :high_sierra
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
