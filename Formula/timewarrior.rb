class Timewarrior < Formula
  desc "Command-line time tracking application"
  homepage "https://timewarrior.net/"
  url "https://github.com/GothenburgBitFactory/timewarrior/releases/download/v1.4.3/timew-1.4.3.tar.gz"
  sha256 "c4df7e306c9a267c432522c37958530b8fd6e5a410c058f575e25af4d8c7ca53"
  license "MIT"
  revision 1
  head "https://github.com/GothenburgBitFactory/timewarrior.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "e28eba2534652ce27707ed9c254f1ee5e975075d828f55a921a0364431fdbd27"
    sha256 cellar: :any_skip_relocation, big_sur:       "101e508c5c0a5103c47ee108cabb0e62d236005625a9825c63410a9e0b045243"
    sha256 cellar: :any_skip_relocation, catalina:      "eb42768965768800442869fab32f020e4d0895a69dbc5272799876bb92b4c6b1"
    sha256 cellar: :any_skip_relocation, mojave:        "18f0a0d7a5077f4d45f796b54ef93146656321dc07fdd1d044e7fedac4f98506"
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
