class X3270 < Formula
  desc "IBM 3270 terminal emulator for the X Window System and Windows"
  homepage "http://x3270.bgp.nu/"
  url "http://x3270.bgp.nu/download/04.01/suite3270-4.1ga11-src.tgz"
  sha256 "c36d12fcf211cce48c7488b06d806b0194c71331abdce6da90953099acb1b0bf"
  license "BSD-3-Clause"

  livecheck do
    url "https://x3270.miraheze.org/wiki/Downloads"
    regex(/href=.*?suite3270[._-]v?(\d+(?:\.\d+)+(?:ga\d+)?)(?:-src)?\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "18f101d5a808cd1991be3966a1e535c9d205a566f73e7a6255b4f0886eaa2c8b"
    sha256 arm64_big_sur:  "9fae3a8f2ddbeceefda9f0db432c690d3a4e3bc60449b2652318a4eac46452a8"
    sha256 monterey:       "6664d1024a700607cf84b5775c71e58ee9ebe6cd890cdf40f27b125ece8c8293"
    sha256 big_sur:        "a7fcecb572d154289a3482fd1bf482018b0056446ea9c854c86c185bd8754eb0"
    sha256 catalina:       "99f3c5d17ddcfeffd43a88c4e55116dd5a0ba59c1fc69ed214e36d70dd95aa78"
    sha256 x86_64_linux:   "aac22fe73d7d53a70811bbfeea8ca25a5c45f86212024bc345b308bc4003a5c1"
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
