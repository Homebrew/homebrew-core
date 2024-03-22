class Xmount < Formula
  desc "Convert between multiple input & output disk image types"
  homepage "https://www.pinguin.lu/xmount/"
  url "https://files.pinguin.lu/xmount-0.7.6.tar.gz"
  sha256 "76e544cd55edc2dae32c42a38a04e11336f4985e1d59cec9dd41e9f9af9b0008"
  license "GPL-3.0-or-later"
  revision 3

  livecheck do
    url "https://deb.debian.org/debian/pool/main/x/xmount/"
    regex(/href=.*?xmount[._-]v?(\d+(?:\.\d+)+)\.orig\.t/i)
  end

  bottle do
    sha256 x86_64_linux: "c61ddafea43cbd071198031f80f4893a2fc90266a9daf1999e78a1b6211d748a"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "afflib"
  depends_on "libewf"
  depends_on "libfuse@2"
  depends_on :linux # on macOS, requires closed-source macFUSE
  depends_on "openssl@3"

  def install
    ENV.prepend_path "PKG_CONFIG_PATH", Formula["openssl@3"].opt_lib/"pkgconfig"

    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    system bin/"xmount", "--version"
  end
end
