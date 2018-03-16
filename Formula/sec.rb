class Sec < Formula
  desc "Event correlation tool for event processing of various kinds"
  homepage "https://simple-evcorr.sourceforge.io/"
  url "https://github.com/simple-evcorr/sec/releases/download/2.7.12/sec-2.7.12.tar.gz"
  sha256 "4ab19f0e9499a071c1e07dddd453faad2cde5e7de2ff187f0eafb2d2a615aa38"

  bottle :unneeded

  def install
    bin.install "sec"
    man1.install "sec.man" => "sec.1"
  end

  test do
    system "#{bin}/sec", "--version"
  end
end
