class Ultralist < Formula
  desc "Simple GTD-style task management for the command-line"
  homepage "https://ultralist.io"
  url "https://github.com/ultralist/ultralist/archive/1.7.0.tar.gz"
  sha256 "d4a524c94c1ea4a748711a1187246ed1fd00eaaafd5b8153ad23b42d36485f79"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "48175adf19c1d24846ff72cc9646a273783aa4dccc1ced94debc349fd972e3d4" => :catalina
    sha256 "597b4205322618c240d72ad4d8344105feeb3ad2bb9393938900c9087579ef91" => :mojave
    sha256 "95ef63755ca09c9487816ee9cadd1a6f2f1ecf3511b6b1ce555efdbbb233632c" => :high_sierra
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
