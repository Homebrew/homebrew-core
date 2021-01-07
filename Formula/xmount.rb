class Xmount < Formula
  desc "Convert between multiple input & output disk image types"
  homepage "https://www.pinguin.lu/xmount/"
  url "https://files.pinguin.lu/xmount-0.7.6.tar.gz"
  sha256 "76e544cd55edc2dae32c42a38a04e11336f4985e1d59cec9dd41e9f9af9b0008"
  revision 2

  bottle do
    rebuild 1
    sha256 "55de429679b12e85dcfb854d4add045363a287c172b7b77765591d7d1d89324c" => :catalina
    sha256 "ae937d5fdba6c278bef72a4f87d62a6dafc2f78ad642ee6995bc228743ed37cd" => :mojave
    sha256 "a4436c7060d9b84abfa6450c7156cd994f42c130eebf1281e21319d6e5c00415" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "afflib"
  depends_on "libewf"
  depends_on "openssl@1.1"

  on_macos do
    deprecate! date: "2020-11-10", because: "requires FUSE"
    depends_on :osxfuse
  end

  on_linux do
    depends_on "libfuse"
  end

  def install
    ENV.prepend_path "PKG_CONFIG_PATH", Formula["openssl@1.1"].opt_lib/"pkgconfig"

    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    system bin/"xmount", "--version"
  end
end
