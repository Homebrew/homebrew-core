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
    sha256 arm64_monterey: "d45dabf8ba9db44f41e8956d3d6b95ae04450d46e5b2ef273b1a8f4d570c5b5c"
    sha256 arm64_big_sur:  "8e4bf45581ee97a1520a34a8ae3881acc6ce4b4b80125e2628dd961b81b042e6"
    sha256 monterey:       "2ddedc6c01120480bbeb2db4cdf0581db3306e81f87ab50d3a807eee993de388"
    sha256 big_sur:        "bc0334fc91e00caabba356e81fecfadcd3f7ec55203ed05123d5a8e3a9f51878"
    sha256 catalina:       "dcfcefa0067895e8c3901cb9e2d057df4bf08d117b0e5073c7146993184de528"
    sha256 x86_64_linux:   "98a6a16988de395270c0bc0eb25d1cfebbff45110c4222aa41f5128a6a4025e8"
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
