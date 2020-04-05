class Truncate < Formula
  desc "Truncates a file to a given size"
  homepage "https://www.vanheusden.com/truncate/"
  url "https://github.com/flok99/truncate/archive/0.9.tar.gz"
  sha256 "a959d50cf01a67ed1038fc7814be3c9a74b26071315349bac65e02ca23891507"
  head "https://github.com/flok99/truncate.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "268e41b71c41a6d5297c7659061953053e2e833bde60d23ff80296950ff4f006" => :catalina
    sha256 "99e774220ef9a0cdb89f4300c671ac9eb74840cf5ed2d0731f12d20e680ff939" => :mojave
    sha256 "e1386eda3a93dddd528d1c3bf33b78c9c4da12039d7434b8db956e05eace9482" => :high_sierra
    sha256 "c4c892f0afbdf3a401ccb0af2a7cf8c65b37ccfdfe2412dda5284faa94f562ff" => :sierra
    sha256 "299b80454c20134c5d0916da25fb3d5f0b6843e620dac6babebe01a899253a69" => :el_capitan
    sha256 "a9d1c87d6cfec42674f0e7db25b786ba100a04c8c0da318fd5f6299a7418843f" => :yosemite
    sha256 "d8751674842b772bd3a5318c1234f262518d05d66a7fe3b06ce5f59b2176bba8" => :mavericks
  end

  conflicts_with "coreutils", :because => "both install `truncate` binaries"

  def install
    system "make"
    bin.install "truncate"
    man1.install "truncate.1"
  end

  test do
    system "#{bin}/truncate", "-s", "1k", "testfile"
  end
end
