class Sfk < Formula
  desc "Command-line tools collection"
  homepage "http://stahlworks.com/dev/swiss-file-knife.html"
  url "https://downloads.sourceforge.net/project/swissfileknife/1-swissfileknife/1.9.7.2/sfk-1.9.7.tar.gz"
  version "1.9.7.2"
  sha256 "d48c446ea849f0cfa1435dd2eb0d5678f7eb781ebfe2cbd155fe46bb2f8ca879"
  license "BSD-2-Clause"

  livecheck do
    url :stable
    regex(%r{url.*?swissfileknife/v?(\d+(?:\.\d+)+)/}i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "246205fa0015ce9b38f100079140aad24fdd215f4efce266e2e4b8f8390c9ea7" => :big_sur
    sha256 "d65ccb8005b80f6235715be44e61d94489bb54215d6fc4e83151447a78742573" => :arm64_big_sur
    sha256 "3d77c49b96cce970358341e21d96d77229c5de7c903baa212fbdc7cbfc1f0a22" => :catalina
    sha256 "ca1b6bf3302da32e47f2d1235262a1b64107351f833a8fca2bd0326c2747954f" => :mojave
    sha256 "8588d84e1d7b52d017a3f5417351eb28f025a8c2cdc31334b67361541d57aee8" => :high_sierra
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/sfk", "ip"
  end
end
