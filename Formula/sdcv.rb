class Sdcv < Formula
  desc "StarDict Console Version"
  homepage "https://dushistov.github.io/sdcv/"
  url "https://github.com/Dushistov/sdcv/archive/v0.5.1.tar.gz"
  sha256 "d0c64429547adb127d5ff9f0f0db8c4bc663bc413dfb5b5d32c924a67171c247"
  version_scheme 1
  head "https://github.com/Dushistov/sdcv.git"

  bottle do
    sha256 "e028819ccfe5e4f702cfc9853124380a5f4523de3f680f04a5cc6613ee720b4b" => :sierra
    sha256 "d6ca2ae4117abc66cb6c9bc771114edcae9a62240e452e79caf02ea90f5e923b" => :el_capitan
    sha256 "2a2b5cec3b4ec59d1b07d67a35cd69b13aa53a96a449a13031aeb9f1936385e5" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "cmake" => :build
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
