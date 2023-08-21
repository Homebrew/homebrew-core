class Sdcv < Formula
  desc "StarDict Console Version"
  homepage "https://dushistov.github.io/sdcv/"
  url "https://github.com/Dushistov/sdcv/archive/v0.5.5.tar.gz"
  sha256 "4d2519e8f8479b9301dc91e9cda3e1eefef19970ece0e8c05f0c7b7ade5dc94b"
  license "GPL-2.0-or-later"
  version_scheme 1
  head "https://github.com/Dushistov/sdcv.git", branch: "master"

  bottle do
    sha256 arm64_ventura:  "f04de637dc02721d831e83b089b85bfc985556faaac0070fefe22a3cc7092170"
    sha256 arm64_monterey: "2f225971eef6a6f8b7b38132e08849c973126533a6e9089f9362674136d178c6"
    sha256 arm64_big_sur:  "2ec8a144f854c615c2e461205ab7ee9ac323ebed46ab7c00067aaf021bea0c88"
    sha256 ventura:        "1f634180a15ceeb5f96805722e3e885dd7e55abfb8a60cedc5628aac51b9d026"
    sha256 monterey:       "6b6f6f0cc8a7b79c11c540dd09ab258f67f8effb4c3b9222eb24c6fe7422de23"
    sha256 big_sur:        "b9500af174861ad2fabb36db77642ff700c2b04c74f0008abb157deac4f4598e"
    sha256 x86_64_linux:   "1d48958b5768fd52938d5358be25d96911066e0b738b0bc75497aae904c98d96"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "glib"
  depends_on "readline"

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
