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
    sha256 "c302f226d12b7712707b4c3927fb1cbdf2c852ab69af36093641197d67641733" => :big_sur
    sha256 "69671313b02b6ec8c1566f0b14ab3fcc66dcc4b5d1303f232912d707df09a26a" => :arm64_big_sur
    sha256 "c8870130d271e11f32bbe6c4ce14458b2811d639aba74286d95250edb0df14cd" => :catalina
    sha256 "a6080a3d7767d3bc8920973cc9a7d61320b1d21102ac483bdb06a0ab7d60c834" => :mojave
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
