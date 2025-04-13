class Sec < Formula
  desc "Event correlation tool for event processing of various kinds"
  homepage "https://simple-evcorr.sourceforge.net/"
  url "https://github.com/simple-evcorr/sec/releases/download/2.9.3/sec-2.9.3.tar.gz"
  sha256 "280f5b94eebbf7efbf5a7d7e417beae75415a7dc5103a2d0fdb3008568fb9f30"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9ec44819d99d5718791528a93a25d3f834f13a47782840eaa2ea33d1e4355fc2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9ec44819d99d5718791528a93a25d3f834f13a47782840eaa2ea33d1e4355fc2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9ec44819d99d5718791528a93a25d3f834f13a47782840eaa2ea33d1e4355fc2"
    sha256 cellar: :any_skip_relocation, sonoma:        "7b4de41cdc038ec4c8740b1193440763a29956ab84d698f1710a1d20c6f10d06"
    sha256 cellar: :any_skip_relocation, ventura:       "7b4de41cdc038ec4c8740b1193440763a29956ab84d698f1710a1d20c6f10d06"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8a177a1143fb753c0e6657473880f30f8d31cccff86b15ac6fac8274375f9d6c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9ec44819d99d5718791528a93a25d3f834f13a47782840eaa2ea33d1e4355fc2"
  end

  def install
    bin.install "sec"
    man1.install "sec.man" => "sec.1"
  end

  test do
    system bin/"sec", "--version"
  end
end
