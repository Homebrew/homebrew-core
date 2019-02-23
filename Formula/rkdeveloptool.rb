class Rkdeveloptool < Formula
  desc "This tool gives you a simple way to read/write Rockchip devices"
  homepage "http://opensource.rock-chips.com/wiki_Rkdeveloptool"
  url "https://github.com/rockchip-linux/rkdeveloptool/archive/72c04fec88b2a3c6136a4aee4747e41c531c4f4b.tar.gz"
  version "1.3"
  sha256 "c2c3a3cc325ccf840e4054d05a794144417dabed8725d9f1e66125b493124865"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "libusb"

  def install
    system "autoreconf", "-i"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/rkdeveloptool", "-v"
  end
end
