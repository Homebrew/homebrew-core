class Sdcv < Formula
  desc "StarDict Console Version"
  homepage "https://dushistov.github.io/sdcv/"
  url "https://github.com/Dushistov/sdcv/archive/v0.5.2.tar.gz"
  sha256 "ec08dc084a0748d5a89df01a20bbf294f09b0366295cd418000f15d2e043c4f7"
  revision 1
  version_scheme 1
  head "https://github.com/Dushistov/sdcv.git"

  bottle do
    sha256 "8284b957b698321f81c7dec19e07a97422f75a5c06b1842216443535024c7c98" => :mojave
    sha256 "ab5c72c084c63e3346ec1f55a9faa9e199d455e5c9cc75bf83ae8e92bfbe9518" => :high_sierra
    sha256 "c30525f5718a726954d88fb28c3fce7a951c0e4f2af34ddf8ab87cbd81ecf046" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "glib"
  depends_on "readline"

  # see: https://github.com/Homebrew/homebrew/issues/26321
  needs :cxx11

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "lang"
      system "make", "install"
    end
  end

  test do
    system bin/"sdcv", "-h"
  end
end
