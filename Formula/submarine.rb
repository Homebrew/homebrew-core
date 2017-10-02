class Submarine < Formula
  desc "Search and download subtitles"
  homepage "https://github.com/rastersoft/submarine"
  url "https://github.com/rastersoft/submarine/archive/0.1.7b.tar.gz"
  version "0.1.7b"
  sha256 "4569710a1aaf6709269068b6b1b2ef381416b81fa947c46583617343b1d3c799"
  head "https://github.com/rastersoft/submarine.git"

  bottle do
    cellar :any
    sha256 "d49929f380ae727fc8b2b6224517f6b34da60de4addb4c2cff7bffa9a00c5f63" => :high_sierra
    sha256 "f81c66ff58be9ed32491ea2044593f29fae46a038f4ab03808ee1e971f624174" => :sierra
    sha256 "1789cc77bd636d2e09c9cafdd9377ad5115be3338f434e1d93b794dae2616eac" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "vala" => :build
  depends_on "glib"
  depends_on "libgee"
  depends_on "libsoup"
  depends_on "libarchive"

  def install
    # Parallelization build failure reported 2 Oct 2017 to rastersoft AT gmail
    ENV.deparallelize
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    system "#{bin}/submarine", "--help"
  end
end
