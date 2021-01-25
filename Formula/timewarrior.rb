class Timewarrior < Formula
  desc "Command-line time tracking application"
  homepage "https://timewarrior.net/"
  url "https://github.com/GothenburgBitFactory/timewarrior/releases/download/v1.4.2/timew-1.4.2.tar.gz"
  sha256 "c3d3992aa8d2cc3cd86e59d00060fb4a3e16c15babce78451cc9d39a7f5bb2e1"
  license "MIT"
  head "https://github.com/GothenburgBitFactory/timewarrior.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "40d7ce6f5802ca1a755f6a722ebcabc68b574632007d95ef109ad99c2e7a4902" => :big_sur
    sha256 "b725f7ad884389a11b3428f43ab9d823e179a5aa679a6506ea0b67eb65007c25" => :arm64_big_sur
    sha256 "4c872f73c14a7219179b3f468d5ceb0739b79ace42e69126f9b3549eac9cba94" => :catalina
    sha256 "336d8bbaf618d17901774358a58772579318a405e7020c63583538283b1f2165" => :mojave
    sha256 "c15692ae447c6364eb7c74665e3b9d8acb01be7f31eb0f4ebaf92d7c7dc3f874" => :high_sierra
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
