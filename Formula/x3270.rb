class X3270 < Formula
  desc "IBM 3270 terminal emulator for the X Window System and Windows"
  homepage "http://x3270.bgp.nu/"
  url "http://x3270.bgp.nu/download/04.00/suite3270-4.0ga10-src.tgz"
  sha256 "05db34a7508a0d61c95a43563472e61d0f7fa12ce0d5f3ed3e5f88e966d8d98c"
  license "BSD-3-Clause"

  livecheck do
    url "http://x3270.bgp.nu/download.html"
    regex(/href=.*?suite3270[._-]v?(\d+(?:\.\d+)+(?:ga\d+)?)(?:-src)?\.t/i)
  end

  bottle do
    sha256 "c6fe40f28c1b0e20cb3ee10280f324ac272f5b4b4fc77209660bf2a095d855a3" => :catalina
    sha256 "6b56b9d4bee80297a4e2ee4e18e1ca50efab5b5870445e7741a2c446732d237d" => :mojave
    sha256 "7de587f8dd4eb24ddd2c2d9ab48b82aa9ca2097cf5797bb8a33c35494acd8840" => :high_sierra
  end

  depends_on "readline"

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
