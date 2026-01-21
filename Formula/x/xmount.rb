class Xmount < Formula
  desc "Convert between multiple input & output disk image types"
  homepage "https://www.sits.lu/xmount"
  url "https://code.sits.lu/foss/xmount/-/archive/1.3.1/xmount-1.3.1.tar.bz2"
  sha256 "422185f1b99ec9e1077201a3a8587fa850068138d1ce685f636305bd19b7a71a"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_linux:  "6364ff6f1f3f58abba37dc41dfabc8d1a937c1866a06de6d41688f1a382c3811"
    sha256 x86_64_linux: "352b5cff0298c4e3f548a11c25695dd9f84cce545f2c04acff2a9d2fc941b159"
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
