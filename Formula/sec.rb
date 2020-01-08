class Sec < Formula
  desc "Event correlation tool for event processing of various kinds"
  homepage "https://simple-evcorr.sourceforge.io/"
  url "https://github.com/simple-evcorr/sec/releases/download/2.8.2/sec-2.8.2.tar.gz"
  sha256 "ec7b30b77221f58de4c91df115b07a9f5de91813f904fd01007632389672aa3c"

  bottle :unneeded

  def install
    bin.install "sec"
    man1.install "sec.man" => "sec.1"
  end

  test do
    system "#{bin}/sec", "--version"
  end
end
