class X3270 < Formula
  desc "IBM 3270 terminal emulator for the X Window System and Windows"
  homepage "http://x3270.bgp.nu/"
  url "http://x3270.bgp.nu/download/04.00/suite3270-4.0ga9-src.tgz"
  sha256 "32dd89393bc9987e0b1fc397a48509ba99a372f19ba21f4d9444034a5f26a24e"

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
