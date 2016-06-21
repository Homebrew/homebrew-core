class Sec < Formula
  desc "Event correlation tool for event processing of various kinds"
  homepage "http://simple-evcorr.sourceforge.net/"
  url "https://github.com/simple-evcorr/sec/releases/download/2.7.10/sec-2.7.10.tar.gz"
  mirror "https://downloads.sourceforge.net/project/simple-evcorr/sec/2.7.10/sec-2.7.10.tar.gz"
  sha256 "8c1441db830d3689aa201c1b0a5e46a97a22e8187d3e0d1c2dbd8abbd47c3d21"

  bottle :unneeded

  def install
    bin.install "sec"
    man1.install "sec.man" => "sec.1"
  end

  test do
    system "#{bin}/sec", "--version"
  end
end
