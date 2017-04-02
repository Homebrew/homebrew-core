class Sec < Formula
  desc "Event correlation tool for event processing of various kinds"
  homepage "https://simple-evcorr.sourceforge.io/"
  url "https://github.com/simple-evcorr/sec/releases/download/2.7.11/sec-2.7.11.tar.gz"
  sha256 "59cd744c36be43c0cb69f1570d2aa6911ebb3492ff01fc292347ec8876dfe991"

  bottle :unneeded

  def install
    bin.install "sec"
    man1.install "sec.man" => "sec.1"
  end

  test do
    system "#{bin}/sec", "--version"
  end
end
