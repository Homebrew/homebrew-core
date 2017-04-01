class Sflowtool < Formula
  desc "Utilities and scripts for analyzing sFlow data"
  homepage "http://www.inmon.com/technology/sflowTools.php"
  url "https://github.com/sflow/sflowtool/releases/download/v3.41/sflowtool-3.41.tar.gz"
  sha256 "0e807f182db5ca5b37d0fb55b77e970b1d51fee0cd8cb845646211befb35ca24"

  bottle do
    cellar :any_skip_relocation
    sha256 "ac55bee65e2e84443119f222b145c1600aeb7630db5cfc822c506b0f6fac3ae1" => :sierra
    sha256 "2c81cf680275146cde13fd6fa0ba0994684c78978b3ad465540a28feb8d123ab" => :el_capitan
    sha256 "f6c5719944abcaed4cd8926deee4e87c72ca6988267dfb1032e6bfb53e77a3f4" => :yosemite
  end

  resource "scripts" do
    url "http://www.inmon.com/bin/sflowutils.tar.gz"
    sha256 "45f6a0f96bdb6a1780694b9a4ef9bbd2fd719b9f7f3355c6af1427631b311d56"
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "check"
    system "make", "install"
    (prefix/"contrib").install resource("scripts")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sflowtool -h 2>&1")
  end
end
