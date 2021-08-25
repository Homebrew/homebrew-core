class Timewarrior < Formula
  desc "Command-line time tracking application"
  homepage "https://timewarrior.net/"
  url "https://github.com/GothenburgBitFactory/timewarrior/releases/download/v1.4.3/timew-1.4.3.tar.gz"
  sha256 "c4df7e306c9a267c432522c37958530b8fd6e5a410c058f575e25af4d8c7ca53"
  license "MIT"
  revision 1
  head "https://github.com/GothenburgBitFactory/timewarrior.git", branch: "dev"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "c237684f26cc8b20162ab44dc3fd1822317bcc7988004ebfaaae1b262706a9c0"
    sha256 cellar: :any_skip_relocation, big_sur:       "408828a1e987d46c028e984d205a05e08e9f1f1c22f2e06f63d83f1c4103abed"
    sha256 cellar: :any_skip_relocation, catalina:      "bfd843a753ea65204f5c2d125a6bfcb97034e5b0ca997c5c224338755e4a1b36"
    sha256 cellar: :any_skip_relocation, mojave:        "adcac7b2fe1e61a589a674b581ad77b2d0f6e6646454d12da192ceb8ff4d8dd1"
  end

  depends_on "asciidoctor" => :build
  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/".timewarrior/data").mkpath
    (testpath/".timewarrior/extensions").mkpath
    touch testpath/".timewarrior/timewarrior.cfg"
    system "man", "-P", "cat", "timew-summary"
    assert_match "Tracking foo", shell_output("#{bin}/timew start foo")
  end
end
