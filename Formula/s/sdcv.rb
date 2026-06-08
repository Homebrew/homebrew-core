class Sdcv < Formula
  desc "StarDict Console Version"
  homepage "https://dushistov.github.io/sdcv/"
  url "https://github.com/Dushistov/sdcv/archive/refs/tags/v0.5.5.tar.gz"
  sha256 "4d2519e8f8479b9301dc91e9cda3e1eefef19970ece0e8c05f0c7b7ade5dc94b"
  license "GPL-2.0-or-later"
  version_scheme 1
  head "https://github.com/Dushistov/sdcv.git", branch: "master"

  bottle do
    rebuild 1
    sha256 arm64_tahoe:   "d9e4a0a1b41d6d46b30202780982c90aff2d19cee7333b5f1e9d0da18cf68f52"
    sha256 arm64_sequoia: "507d6ed1c271d67f1803267eacffaec3b80dc1bb028683e6461874f0656a7937"
    sha256 arm64_sonoma:  "325be709ff03b8fc16ab595119d730066cc2299b3b8b214b4d20a8cf467e0d5b"
    sha256 sonoma:        "a6a1dde20c0f583b113044908921e95fc76a3ad14195e68e242e0aa2bb6ce255"
    sha256 arm64_linux:   "c48568253dc9cfbcdfe4f4aa520303a3d6cd51cffc2e4b88b8c2a39e2c94271f"
    sha256 x86_64_linux:  "d01d6330eecd4858e0c73ea360a0f6870ce3004f7c97bce3284c64a9ae850d6f"
  end

  depends_on "cmake" => :build
  depends_on "gettext" => :build
  depends_on "pkgconf" => :build

  depends_on "glib"
  depends_on "readline"

  on_macos do
    depends_on "gettext"
  end

  on_linux do
    depends_on "zlib-ng-compat"
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
