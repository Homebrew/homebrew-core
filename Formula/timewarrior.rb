class Timewarrior < Formula
  desc "Command-line time tracking application"
  homepage "https://taskwarrior.org/docs/timewarrior/"
  url "https://taskwarrior.org/download/timew-1.0.0.tar.gz"
  sha256 "ac027910e1e8365bdd218a8b42389b26d017d38d3c96516c408db6d5a44e0bb5"
  head "https://git.tasktools.org/scm/tm/timew.git"

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
