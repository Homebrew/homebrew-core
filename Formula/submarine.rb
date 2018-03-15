class Submarine < Formula
  desc "Search and download subtitles"
  homepage "https://github.com/rastersoft/submarine"
  url "https://github.com/rastersoft/submarine/archive/0.1.7b.tar.gz"
  version "0.1.7b"
  sha256 "4569710a1aaf6709269068b6b1b2ef381416b81fa947c46583617343b1d3c799"
  head "https://github.com/rastersoft/submarine.git"

  bottle do
    cellar :any
    sha256 "0f69e16c6289fe9f529d2d972b91f86f5b950f31f0d9b7d2af3d80f4cc344de3" => :high_sierra
    sha256 "05cb83f2ed8dd62e4417bc4f9e65c6a4ad5127b0012296676033ee92346d3789" => :sierra
    sha256 "71ed7dcec2639d658412e8c099c4440bbb6f00d32cf80b9be8954abef07d0c21" => :el_capitan
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
