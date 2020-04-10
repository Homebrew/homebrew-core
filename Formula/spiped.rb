class Spiped < Formula
  desc "Secure pipe daemon"
  homepage "https://www.tarsnap.com/spiped.html"
  url "https://www.tarsnap.com/spiped/spiped-1.6.1.tgz"
  sha256 "8d7089979db79a531a0ecc507b113ac6f2cf5f19305571eff1d3413e0ab33713"

  bottle do
    cellar :any
    sha256 "725b6f32ffe438ebda806ae225f81e801fd5f97592649984564ecc5a8352e8a1" => :catalina
    sha256 "3b395a73b22765da7859db5c5bb39291b6e748b29d52174be4944dedecf8e5f2" => :mojave
    sha256 "dfe6aac663c1f2196eb20aa617e576bdec5775a8426d0860848be734a9b2b86d" => :high_sierra
    sha256 "39af54b67bbd4b6dd9d35bcd7d6a36cef8e9ebc936116ca60ab189f0a2127b4b" => :sierra
  end

  depends_on "bsdmake" => :build
  depends_on "openssl@1.1"

  def install
    man1.mkpath
    system "bsdmake", "BINDIR_DEFAULT=#{bin}", "MAN1DIR=#{man1}", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/spipe -v 2>&1")
  end
end
