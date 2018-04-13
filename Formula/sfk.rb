class Sfk < Formula
  desc "Command-line tools collection"
  homepage "http://stahlworks.com/dev/swiss-file-knife.html"
  url "https://downloads.sourceforge.net/project/swissfileknife/1-swissfileknife/1.9.1.0/sfk-1.9.1.tar.gz"
  version "1.9.1.0"
  sha256 "4b856d98de359de1f0ec7cb1eaaf8c4f75e7f8f22194db8530d6bf3b27fa0eda"

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
