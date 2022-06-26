class X3270 < Formula
  desc "IBM 3270 terminal emulator for the X Window System and Windows"
  homepage "http://x3270.bgp.nu/"
  url "http://x3270.bgp.nu/download/04.02/suite3270-4.2ga4-src.tgz"
  sha256 "6a89ebdc7817bc204f79ebcdc6b5e7fef8c19aedfbc80284fedc647caa086790"
  license "BSD-3-Clause"
  revision 1

  livecheck do
    url "https://x3270.miraheze.org/wiki/Downloads"
    regex(/href=.*?suite3270[._-]v?(\d+(?:\.\d+)+(?:ga\d+)?)(?:-src)?\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "d9159e0e87f2b97139014bc2a9de458091bba367e7e3f55553a9231f96c21155"
    sha256 arm64_big_sur:  "06ebc3e2c167786c9dec69cb576192c2d29183a048ee5a7a3fa17c3c4ede9662"
    sha256 monterey:       "7f1a5543a0c0914971ca774c876cfdcb5ac507fc53ed18bde8892f5bd49ebf6f"
    sha256 big_sur:        "c030a3f1f70b3fca2a0fdf025c55dc0b81cd9d97fcc0d78bcb3bff1f1cbfb73f"
    sha256 catalina:       "c591165dffd8b6ae563b56cceef13eba6cbb6d342f7e521bd19d7aec6bc95cc0"
    sha256 x86_64_linux:   "229f9ee30e9baa3bf32de8b2839b25d132dc9d3fadb0034e47e9c1dd30414073"
  end

  depends_on "readline"

  uses_from_macos "tcl-tk"

  # Apply patch on 4.2ga4. Remove after next release
  # https://github.com/pmattes/x3270/issues/36
  patch do
    url "https://github.com/pmattes/x3270/commit/80168fbc69544fee00517fb5b14bc662501929b8.patch?full_index=1"
    sha256 "a1a00c9396e565879e3cb5ff230861c914ebdf82e44911dd2799c43e2e2ccfad"
  end

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
