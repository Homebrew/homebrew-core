class Xmount < Formula
  desc "Convert between multiple input & output disk image types"
  homepage "https://www.pinguin.lu/xmount/"
  url "https://files.pinguin.lu/xmount-0.7.6.tar.gz"
  sha256 "76e544cd55edc2dae32c42a38a04e11336f4985e1d59cec9dd41e9f9af9b0008"
  license "GPL-3.0-or-later"
  revision 2

  bottle do
    rebuild 1
    sha256 x86_64_linux: "e33278ea02578921565961c9671d64fe13d5290a0f3bf0db08e636099c382fb8"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "afflib"
  depends_on "libewf"
  depends_on "libfuse@2"
  depends_on :linux # on macOS, requires closed-source macFUSE
  depends_on "openssl@1.1"

  def install
    ENV.prepend_path "PKG_CONFIG_PATH", Formula["openssl@1.1"].opt_lib/"pkgconfig"

    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    system bin/"xmount", "--version"
  end
end
