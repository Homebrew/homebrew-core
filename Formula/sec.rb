class Sec < Formula
  desc "Event correlation tool for event processing of various kinds"
  homepage "https://simple-evcorr.sourceforge.io/"
  url "https://github.com/simple-evcorr/sec/releases/download/2.8.1/sec-2.8.1.tar.gz"
  sha256 "342464b2494f4c64eaac3c0f4c53486ea5464f24d8a190c27615850b9d4fe100"

  bottle :unneeded

  def install
    bin.install "sec"
    man1.install "sec.man" => "sec.1"
  end

  test do
    system "#{bin}/sec", "--version"
  end
end
