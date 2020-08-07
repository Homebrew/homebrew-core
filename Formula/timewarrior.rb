class Timewarrior < Formula
  desc "Command-line time tracking application"
  homepage "https://timewarrior.net/"
  url "https://github.com/GothenburgBitFactory/timewarrior/releases/download/v1.3.0/timew-1.3.0.tar.gz"
  sha256 "1f3b9166a96637d3c098a7cfcff74ca61c41f13e2ca21f6c7ad6dd54cc74ac70"
  license "MIT"
  head "https://github.com/GothenburgBitFactory/timewarrior.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "b31a1b3ffe25ae8e006e172a228a6c02b749fc0a121957b076a2ed0125ad434e" => :catalina
    sha256 "b09c7933fd20dae4a309a6cf278b63ff6317944e2298a3dd290acbb62dc87fb6" => :mojave
    sha256 "6a4ec380d1c382da7e67bed6072ebe20365a72a1f098e62e25d4840488e5718c" => :high_sierra
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
