class Xmount < Formula
  desc "Convert between multiple input & output disk image types"
  homepage "https://www.sits.lu/xmount"
  url "https://code.sits.lu/foss/xmount/-/archive/1.2.1/xmount-1.2.1.tar.bz2"
  sha256 "14cbbbebcdf1a540d79f64ac24b37882a694292e60afdee1c6923b8baf3eb877"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_linux:  "3e4054ba9bd6912e191450e8579069e009b7564c95981ae563a97a4362cf7d22"
    sha256 x86_64_linux: "5b56b805ee90090f81f39d5825499557e7fbf4073b9e7d11f7265ac3ad15bf09"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "afflib"
  depends_on "libewf"
  depends_on "libfuse"
  depends_on :linux # on macOS, requires closed-source macFUSE
  depends_on "zlib"

  def install
    system "cmake", "-S", ".", "-B", "build", "-DCMAKE_POLICY_VERSION_MINIMUM=3.5", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system bin/"xmount", "--version"
  end
end
