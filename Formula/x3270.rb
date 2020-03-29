class X3270 < Formula
  desc "IBM 3270 terminal emulator for the X Window System and Windows"
  homepage "http://x3270.bgp.nu/"
  url "https://downloads.sourceforge.net/project/x3270/x3270/3.6ga9/suite3270-3.6ga9-src.tgz"
  sha256 "674689a12d09ed9097d9d62a2422e65bf6d40c06dd217f0d618fb7e3673b7568"

  bottle do
    sha256 "4a688250d91e04d91aa9c0983f630fe0b682d35769387e4fa490f03f977be7fb" => :catalina
    sha256 "c5448a7a24aa77b54c9473ea62b4aeac4c87930e79bc7a229dea02427d87c1fe" => :mojave
    sha256 "962a25eb052b7f3f2a8c01fd1f2d0e90c5e70fd91ac7c63a038a4fd710661557" => :high_sierra
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
