class Xmount < Formula
  desc "Convert between multiple input & output disk image types"
  homepage "https://www.sits.lu/xmount"
  url "https://code.sits.lu/foss/xmount/-/archive/1.3.1/xmount-1.3.1.tar.bz2"
  sha256 "422185f1b99ec9e1077201a3a8587fa850068138d1ce685f636305bd19b7a71a"
  license "GPL-3.0-or-later"

  bottle do
    rebuild 1
    sha256 arm64_linux:  "8d3444a83f6d79aa7b8034a4bcc93a3d2711b7209911ce0fd3b733011b94d2da"
    sha256 x86_64_linux: "fe78cd0d0609e30fa63acce7871b03734181cb931948485158b70b687082a1c8"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "afflib"
  depends_on "libewf"
  depends_on "libfuse"
  depends_on :linux # on macOS, requires closed-source macFUSE
  depends_on "zlib-ng-compat"

  def install
    system "cmake", "-S", ".", "-B", "build", "-DCMAKE_POLICY_VERSION_MINIMUM=3.5", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system bin/"xmount", "--version"
  end
end
