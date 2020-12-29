class X3270 < Formula
  desc "IBM 3270 terminal emulator for the X Window System and Windows"
  homepage "http://x3270.bgp.nu/"
  url "http://x3270.bgp.nu/download/04.00/suite3270-4.0ga13-src.tgz"
  sha256 "eb39f1b65dfdc9b912301d7a7f269f4d92043223a5196bcfd7e8d7bdf2c95fcf"
  license "BSD-3-Clause"

  livecheck do
    url "http://x3270.bgp.nu/download.html"
    regex(/href=.*?suite3270[._-]v?(\d+(?:\.\d+)+(?:ga\d+)?)(?:-src)?\.t/i)
  end

  bottle do
    sha256 "6debec33ebab916d38e8f4543e8bc22a18a8e7e1d6474277bea040bd63a52e60" => :big_sur
    sha256 "1a673289bc4538fd2e1592548562a3fec3c1a789e0e87452dfad68d4f2f1e619" => :arm64_big_sur
    sha256 "910cfb45bab78112705869fd8bb3fac970d0bd84194ab9555635ff484d355bcb" => :catalina
    sha256 "99fbe83bf0dfbfab1f11b536608d02cd93d530eca7f0ec72ebde4d4424293444" => :mojave
    sha256 "e30468e4081beeab927279e9317f30107db6391ac4e8f9f5334d2ecc0e8e57e2" => :high_sierra
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
