class Xmount < Formula
  desc "Convert between multiple input & output disk image types"
  homepage "https://www.sits.lu/xmount"
  url "https://code.sits.lu/foss/xmount/-/archive/1.3.0/xmount-1.3.0.tar.bz2"
  sha256 "cc5bc2ac00c734f5a9f7fadce48c9a22d9923d363d782374a9b747f52f271555"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_linux:  "4c74f5c52e9062ee34d3159d35725a808a084a350eaaccb3584dacd8ec91edc3"
    sha256 x86_64_linux: "769d0e284fe04e47c8074df8cff9b31fd5781055b0397dd35fa6aba6e9db5cc8"
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
