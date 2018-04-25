class Sfk < Formula
  desc "Command-line tools collection"
  homepage "http://stahlworks.com/dev/swiss-file-knife.html"
  url "https://downloads.sourceforge.net/project/swissfileknife/1-swissfileknife/1.9.1.2/sfk-1.9.1.tar.gz"
  version "1.9.1.2"
  sha256 "9c44787b5fadc2e8ddf6ef518ecf4a50784021f9438e83132a2411c3befd7c22"

  bottle do
    cellar :any_skip_relocation
    sha256 "a346748a5770b74ef3e2127b1b37bb6600aec9af3e2a72d8883a580a44f33d0d" => :high_sierra
    sha256 "ed632ffd40b925be528bd220ce628db5b820820cc1581f17f2043b3327bcd2fd" => :sierra
    sha256 "ec2d63fd18b70425188c43aeb6f24e3773de08a16aa6cc8b361a28f891073237" => :el_capitan
  end

  def install
    ENV.libstdcxx

    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/sfk", "ip"
  end
end
