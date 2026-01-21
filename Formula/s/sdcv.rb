class Sdcv < Formula
  desc "StarDict Console Version"
  homepage "https://dushistov.github.io/sdcv/"
  url "https://github.com/Dushistov/sdcv/archive/refs/tags/v0.5.5.tar.gz"
  sha256 "4d2519e8f8479b9301dc91e9cda3e1eefef19970ece0e8c05f0c7b7ade5dc94b"
  license "GPL-2.0-or-later"
  version_scheme 1
  head "https://github.com/Dushistov/sdcv.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 arm64_tahoe:    "a0086f2d9a94f6adb1ab39c04e4f038438c9899a8bf82b2c7b14d99ccd341bda"
    sha256 arm64_sequoia:  "b53341800d7aad1fae6fd3b105de15a7b1f81e4192d350b50cc4f389e21298da"
    sha256 arm64_sonoma:   "7c16b9b5e5b3ae014c182f84df89c800bd60cf9da4a0b1c0fda724dfb42d991c"
    sha256 arm64_ventura:  "f04de637dc02721d831e83b089b85bfc985556faaac0070fefe22a3cc7092170"
    sha256 arm64_monterey: "2f225971eef6a6f8b7b38132e08849c973126533a6e9089f9362674136d178c6"
    sha256 arm64_big_sur:  "2ec8a144f854c615c2e461205ab7ee9ac323ebed46ab7c00067aaf021bea0c88"
    sha256 sonoma:         "642c8bf7dddb3cda5cc973a74bec82fcddd7ea887e29204147f9337bd70901ab"
    sha256 ventura:        "1f634180a15ceeb5f96805722e3e885dd7e55abfb8a60cedc5628aac51b9d026"
    sha256 monterey:       "6b6f6f0cc8a7b79c11c540dd09ab258f67f8effb4c3b9222eb24c6fe7422de23"
    sha256 big_sur:        "b9500af174861ad2fabb36db77642ff700c2b04c74f0008abb157deac4f4598e"
    sha256 arm64_linux:    "6506b6d3a7602edd66c068de46f433710a9487ed13e8bc9d93581111e4d09e6a"
    sha256 x86_64_linux:   "1d48958b5768fd52938d5358be25d96911066e0b738b0bc75497aae904c98d96"
  end

  depends_on "cmake" => :build
  depends_on "gettext" => :build
  depends_on "pkgconf" => :build

  depends_on "glib"
  depends_on "readline"

  uses_from_macos "zlib"

  on_macos do
    depends_on "gettext"
  end

  # fix type mismatch and memory deallocation build errors
  # upstream PR ref, https://github.com/Dushistov/sdcv/pull/103
  patch do
    url "https://github.com/Dushistov/sdcv/commit/c2bb4e3fe51f9b9940440ea81d5d97b56d5582e7.patch?full_index=1"
    sha256 "70c4c826c2dcd4c0aad5fa8f27b7e079f4461cfbbb380b4726aa4dfd8fb75a1c"
  end

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build", "--target", "lang"
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system bin/"sdcv", "-h"
  end
end
