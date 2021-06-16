class Sec < Formula
  desc "Event correlation tool for event processing of various kinds"
  homepage "https://simple-evcorr.sourceforge.io/"
  url "https://github.com/simple-evcorr/sec/releases/download/2.9.0/sec-2.9.0.tar.gz"
  sha256 "741154d25db69706e2200e119b5cd32d65ae0b803d9c0faefcccfbcfe1c97503"
  license "GPL-2.0-or-later"

  def install
    bin.install "sec"
    man1.install "sec.man" => "sec.1"
  end

  test do
    system "#{bin}/sec", "--version"
  end
end
