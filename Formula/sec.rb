class Sec < Formula
  desc "Event correlation tool for event processing of various kinds"
  homepage "https://simple-evcorr.sourceforge.io/"
  url "https://github.com/simple-evcorr/sec/releases/download/2.8.3/sec-2.8.3.tar.gz"
  sha256 "b376b64ed5be19b28101d974ac4d60c06a1f52cc3d8ba63829a18a6f903dfd29"

  bottle :unneeded

  def install
    bin.install "sec"
    man1.install "sec.man" => "sec.1"
  end

  test do
    system "#{bin}/sec", "--version"
  end
end
