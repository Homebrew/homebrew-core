class Submarine < Formula
  desc "Search and download subtitles"
  homepage "https://github.com/rastersoft/submarine"
  url "https://github.com/rastersoft/submarine/archive/0.1.7.tar.gz"
  sha256 "c8f34bd3f0785abc2e89bc05d9cba8b5756ec12f989b55d207bbf3d021b66bbf"
  head "https://github.com/rastersoft/submarine.git"

  bottle do
    cellar :any
    sha256 "7c557af8e176bc5d6d437d900a280ebb9d4cbd867408ffdcd29dd9e44a9978a7" => :high_sierra
    sha256 "4c57d03fde5cb8ee472f9570d88cc8e8987fbf9280b95ebfe78427fde913e72f" => :sierra
    sha256 "36f4b8efc06f041c77315cffc8739bbead67cd501208c93f168893f295a70f94" => :el_capitan
    sha256 "98e2e4d767aacfb27e6989d1205cb2489b52222ea4f5586e89c0366e4721278b" => :yosemite
    sha256 "317136a44b158c1881eef04c5942c4868575a0fc46095955beedda56d3e7527e" => :mavericks
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "vala" => :build
  depends_on "glib"
  depends_on "libgee"
  depends_on "libsoup"
  depends_on "libarchive"

  def install
    # Parallelization and CMake build failures reported 2 Oct 2017 to
    # rastersoft AT gmail DOT com
    ENV.deparallelize
    cp "src/Config.vala.cmake", "src/Config.vala.base"
    cp "src/lib/Config.vala.cmake", "src/lib/Config.vala.base"

    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    system "#{bin}/submarine", "--help"
  end
end
