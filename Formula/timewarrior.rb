class Timewarrior < Formula
  desc "Command-line time tracking application"
  homepage "https://timewarrior.net/"
  url "https://github.com/GothenburgBitFactory/timewarrior/releases/download/v1.2.0/timew-1.2.0.tar.gz"
  sha256 "2c4d153105a32536ae328038246ebd846a5abd96df7ed29c11100866eaed8e3c"
  head "https://github.com/GothenburgBitFactory/timewarrior.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "8bf48d94c71fabbd3ded0432500495c330374693e8c4960f1dc5f0a90dd6c3b0" => :catalina
    sha256 "708b85bb339ff690ab4cc6b58bb4b97f90494c5f117980c2bc9290887c3d76e6" => :mojave
    sha256 "18ee4385567276d5e73e63bc197954473a7cb1aaccbdf52325b1118c719c5914" => :high_sierra
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
