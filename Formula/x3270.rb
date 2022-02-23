class X3270 < Formula
  desc "IBM 3270 terminal emulator for the X Window System and Windows"
  homepage "http://x3270.bgp.nu/"
  url "http://x3270.bgp.nu/download/04.01/suite3270-4.1ga12-src.tgz"
  sha256 "262489641a60321a06b20ea94ac1ed204e04c4749eb1df1b9e21d0034bc17fef"
  license "BSD-3-Clause"

  livecheck do
    url "https://x3270.miraheze.org/wiki/Downloads"
    regex(/href=.*?suite3270[._-]v?(\d+(?:\.\d+)+(?:ga\d+)?)(?:-src)?\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "b46dc2313d27f76cb4ac5e26f9ec849f0e5f01742cb92633bea3720966c5c924"
    sha256 arm64_big_sur:  "e81f54b7ebd7b7605977bc8f91e4c759e82705cfdb921de4b360cf721f7033c9"
    sha256 monterey:       "8839ce60bddec4db8bed9eabf2c11c238064047f17f6591b089746fb38eee46d"
    sha256 big_sur:        "b187327eb84b4af647a943b23b8271074418669222a9e74ef38f9fe53dece2a9"
    sha256 catalina:       "15a1ddd828d6140a308566724c27e85943d9ef19544fe2b6bfff7801deb3f94a"
    sha256 x86_64_linux:   "4baa2486791d159c0dda18dc1a60097c1ec6ba6ace78a7fcc431ff8505087cce"
  end

  depends_on "readline"

  uses_from_macos "tcl-tk"

  def install
    args = %W[
      --prefix=#{prefix}
      --enable-c3270
      --enable-pr3287
      --enable-s3270
      --enable-tcl3270
    ]
    system "./configure", *args
    system "make", "install"
    system "make", "install.man"
  end

  test do
    system bin/"c3270", "--version"
  end
end
