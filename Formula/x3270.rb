class X3270 < Formula
  desc "IBM 3270 terminal emulator for the X Window System and Windows"
  homepage "http://x3270.bgp.nu/"
  url "http://x3270.bgp.nu/download/04.00/suite3270-4.0ga14-src.tgz"
  sha256 "9796f2b47ed222776d4fe2756a0db3617f84dbbf02d0a9374c36a13b1b416375"
  license "BSD-3-Clause"

  livecheck do
    url "https://x3270.miraheze.org/wiki/Downloads"
    regex(/href=.*?suite3270[._-]v?(\d+(?:\.\d+)+(?:ga\d+)?)(?:-src)?\.t/i)
  end

  bottle do
    sha256 arm64_big_sur: "bf8dcba7b17bb1ebc1fdf8987badc037236e2f83c20a5621c914295355e0f545"
    sha256 big_sur:       "0fb9e40a2f6d56e3f166d7cee9ef8eae4166e3e038c19b114ff840e33a3aad3e"
    sha256 catalina:      "1e8f59bedd3fbda46cab9db08944ab21b3549f9ca9002423590015da3cf75ce6"
    sha256 mojave:        "50108883c53cb6ef78dd63372952451db9d182d4409e340a31146397fbacaf93"
    sha256 x86_64_linux:  "124969949fae4335c0239e9d77fa2daac3035b4313bcb1f17b0ff93d90fe9a89"
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
