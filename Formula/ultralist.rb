class Ultralist < Formula
  desc "Simple GTD-style task management for the command-line"
  homepage "https://ultralist.io"
  url "https://github.com/ultralist/ultralist/archive/1.6.2.tar.gz"
  sha256 "cd7b585cf98952442ed8c4451ebd9b724d1feb57b4732512f6cde91860d7e8a3"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "30528cb69a29e89460fe3d8708237958a3491844a64a15344027cf2a2fa81726" => :catalina
    sha256 "f2ca31deb4b25c5cb5701daac7790c1173a41731ecc0f84529f1bc372706cabb" => :mojave
    sha256 "53f16cd22415f65116445fc67fc6822c2478ef8e6fe2082d9f4becc1671e2d7f" => :high_sierra
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
