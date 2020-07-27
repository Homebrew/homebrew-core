class X3270 < Formula
  desc "IBM 3270 terminal emulator for the X Window System and Windows"
  homepage "http://x3270.bgp.nu/"
  url "http://x3270.bgp.nu/download/04.00/suite3270-4.0ga10-src.tgz"
  sha256 "05db34a7508a0d61c95a43563472e61d0f7fa12ce0d5f3ed3e5f88e966d8d98c"
  license "BSD-3-Clause"

  bottle do
    sha256 "0a97545f8a95a71631e033a52b15a99c36ba620d5e79a62fb8f4e947ed48b827" => :catalina
    sha256 "1cb7acd49a6aadfbda744a7bd29a5002b0f521ebe989ee9b866c2e172051e964" => :mojave
    sha256 "eadc86529406c0c5a2e5b5a3182037b1341eb4ef4326421722faa35edfbdf07a" => :high_sierra
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
