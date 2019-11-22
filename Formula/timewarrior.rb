class Timewarrior < Formula
  desc "Command-line time tracking application"
  homepage "https://taskwarrior.org/docs/timewarrior/"
  url "https://taskwarrior.org/download/timew-1.1.1.tar.gz"
  sha256 "1f7d9a62e55fc5a3126433654ccb1fd7d2d135f06f05697f871897c9db77ccc9"
  head "https://github.com/GothenburgBitFactory/timewarrior.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "021d9b46180d9644c6c5096c8b687c01ddc8fdf517e323870116bc02cbcfdeff" => :catalina
    sha256 "48af9bcedd665d7c2541eb3edc9ed14bccf26a1b3861e295b971ed1d8c2cedc6" => :mojave
    sha256 "add032f6bd1e1b67ff81902522473f6c46e232a097d338b711110a8dea7fc622" => :high_sierra
    sha256 "79da22a5383fdd5e22eff38ac9deb005c745e78764e1278909b8488cc770dd0d" => :sierra
    sha256 "71c77b016f36f2aa46d7aa823b9c7dead64f99d6a7458561caa76bb6c8d1c11f" => :el_capitan
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
