class Sispmctl < Formula
  desc "Control Gembird SIS-PM programmable power outlet strips"
  homepage "https://sispmctl.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/sispmctl/sispmctl/sispmctl-4.1/sispmctl-4.1.tar.gz"
  sha256 "bf5177e085cb0168e18e4cfb69645c3095da149ed46f5659d6e757bde3548e40"

  bottle do
    sha256 "a0e38f978bac7b89863fa074e677a98201de43873640ec84e75d79fe09d82d3e" => :mojave
    sha256 "8c6cd9f2630f34134abe1e2818a3c3d84562fcd08572b7657dd30cf47baadb2c" => :high_sierra
    sha256 "03fac970edbcefa83cd75573a1c82a8d4b1dbd9d531c56aa6ad5367f80057e21" => :sierra
  end

  depends_on "pkg-config" => :build
  depends_on "libusb-compat"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sispmctl -v 2>&1")
  end
end
