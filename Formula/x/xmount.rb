class Xmount < Formula
  desc "Convert between multiple input & output disk image types"
  homepage "https://www.sits.lu/xmount"
  url "https://code.sits.lu/foss/xmount/-/archive/1.2.0/xmount-1.2.0.tar.bz2"
  sha256 "07c261e54e1e4cbcd4f7eaaf4f62efcbbbc68c76797ddca704592d99ebed3d10"
  license "GPL-3.0-or-later"
  revision 1

  bottle do
    sha256 arm64_linux:  "1de5d61365c208673d84f059724faff5d1930c9807579ac6b05627546717bc8f"
    sha256 x86_64_linux: "1b6e3ef254b9fb27d176d6af4ecebda6c9b44f3b02244e543295a03d20831d97"
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
