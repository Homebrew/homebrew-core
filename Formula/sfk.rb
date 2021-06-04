class Sfk < Formula
  desc "Command-line tools collection"
  homepage "http://stahlworks.com/dev/swiss-file-knife.html"
  url "https://downloads.sourceforge.net/project/swissfileknife/1-swissfileknife/1.9.8.0/sfk-1.9.8.tar.gz"
  version "1.9.8.0"
  sha256 "837c7a3fabd1549c0ea5748d05ece5f259d906358226ce04799c4c13e59f1968"
  license "BSD-2-Clause"

  livecheck do
    url :stable
    regex(%r{url.*?swissfileknife/v?(\d+(?:\.\d+)+)/}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "d65ccb8005b80f6235715be44e61d94489bb54215d6fc4e83151447a78742573"
    sha256 cellar: :any_skip_relocation, big_sur:       "246205fa0015ce9b38f100079140aad24fdd215f4efce266e2e4b8f8390c9ea7"
    sha256 cellar: :any_skip_relocation, catalina:      "3d77c49b96cce970358341e21d96d77229c5de7c903baa212fbdc7cbfc1f0a22"
    sha256 cellar: :any_skip_relocation, mojave:        "ca1b6bf3302da32e47f2d1235262a1b64107351f833a8fca2bd0326c2747954f"
    sha256 cellar: :any_skip_relocation, high_sierra:   "8588d84e1d7b52d017a3f5417351eb28f025a8c2cdc31334b67361541d57aee8"
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
