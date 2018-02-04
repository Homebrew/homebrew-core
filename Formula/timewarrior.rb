class Timewarrior < Formula
  desc "Command-line time tracking application"
  homepage "https://taskwarrior.org/docs/timewarrior/"
  url "https://taskwarrior.org/download/timew-1.1.1.tar.gz"
  sha256 "1f7d9a62e55fc5a3126433654ccb1fd7d2d135f06f05697f871897c9db77ccc9"
  head "https://git.tasktools.org/scm/tm/timew.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "8905341524b1be56c250879a17def7cf0a4c7b33f384c80d4e8358e00f2b91d8" => :high_sierra
    sha256 "c697c5a15e3b126af5ce256f03890e8a697174617b289de9397afc46aa00cafa" => :sierra
    sha256 "a109c481c8bc856e7b57c6d27561d1df3ab2d9435b4841119a5daae293ee25ac" => :el_capitan
    sha256 "d8fee526dd540031a9923ecc20174ac0c4d46113ab11548d74110ce4c11e27da" => :yosemite
    sha256 "eddc5acf58ca77536d58803b1cea70a5527dee135b8a89394cb50a78c9d3ed89" => :mavericks
  end

  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/".timewarrior/data").mkpath
    (testpath/".timewarrior/extensions").mkpath
    touch testpath/".timewarrior/timewarrior.cfg"
    assert_match "Tracking foo", shell_output("#{bin}/timew start foo")
  end
end
