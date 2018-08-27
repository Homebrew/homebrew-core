class Submarine < Formula
  desc "Search and download subtitles"
  homepage "https://github.com/rastersoft/submarine"
  url "https://github.com/rastersoft/submarine/archive/0.1.7b.tar.gz"
  version "0.1.7b"
  sha256 "4569710a1aaf6709269068b6b1b2ef381416b81fa947c46583617343b1d3c799"
  revision 1
  head "https://github.com/rastersoft/submarine.git"

  bottle do
    cellar :any
    sha256 "8ece8523d5aa8dfa1342a69731d4aab7c9c595598f17a1c9a5c0ec13abd0ed91" => :mojave
    sha256 "b8ad1b8a4b3da401d17bd7e05765dcd50b552e95e753bbca9d05ccf8d0181e14" => :high_sierra
    sha256 "c274540c9b0662f09251420b3237538025e6f68587d330fcd31589683d065550" => :sierra
    sha256 "a01b0ed5b8bebd9c6619267d2a1f405d139f2f5fb77e55e1a6dcd7c21cb1ecfe" => :el_capitan
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
