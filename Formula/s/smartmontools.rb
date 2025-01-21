class Smartmontools < Formula
  desc "SMART hard drive monitoring"
  homepage "https://www.smartmontools.org/"
  url "https://downloads.sourceforge.net/project/smartmontools/smartmontools/7.4/smartmontools-7.4.tar.gz"
  sha256 "e9a61f641ff96ca95319edfb17948cd297d0cd3342736b2c49c99d4716fb993d"
  license "GPL-2.0-or-later"

  bottle do
    sha256 arm64_sequoia:  "0e5d1e5a5d10a828dbab10ff12bf9eb2a47b1400fbbe048acc2e7d8c538cc6e2"
    sha256 arm64_sonoma:   "44d675190914c3c633fb3c28ccc7da1de5d6957d1c4e0a8a77cda217c3f5111f"
    sha256 arm64_ventura:  "eadf0136194babe18f8ba718079138758e6c01c2d46fbc2c0b8926e9acbb2bf8"
    sha256 arm64_monterey: "7f22083ffb3f4e1a58c2ecaa898746d920f088eebb58861576b5a10b5c1ee59d"
    sha256 arm64_big_sur:  "2fd3b5b51d884f57c8799a413dabd08d5efc2294ef25d2e0ecd45fcb9fbd8559"
    sha256 sonoma:         "857006bab9215b9d49a579750fe6fe8590d6c06556c3995a99c2677cb19925fa"
    sha256 ventura:        "28d25bdbce8bee1b4a7688616918bc736b9c77ffd2527c9bfec0753e5abed804"
    sha256 monterey:       "873861115ecd80333df0d3f5971e15c7341a016b14a612feb0de789da4396aa9"
    sha256 big_sur:        "a6a467130de3c574637ecf611f9b1747578c46537cdd8ed7b73d7d7faf3146c7"
    sha256 x86_64_linux:   "0507b353613d5bb2f79dc75405840bf8b36e38551debf418680035e1aa89b775"
  end

  def install
    (var/"run").mkpath
    (var/"lib/smartmontools").mkpath

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--sbindir=#{bin}",
                          "--sysconfdir=#{etc}",
                          "--localstatedir=#{var}",
                          "--with-savestates",
                          "--with-attributelog",
                          "--with-nvme-devicescan"
    system "make", "install"
  end

  test do
    system bin/"smartctl", "--version"
    system bin/"smartd", "--version"
  end
end
