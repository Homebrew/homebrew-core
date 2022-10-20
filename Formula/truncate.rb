class Truncate < Formula
  desc "Truncates a file to a given size"
  homepage "https://www.vanheusden.com/truncate/"
  url "https://github.com/flok99/truncate/archive/0.9.tar.gz"
  sha256 "a959d50cf01a67ed1038fc7814be3c9a74b26071315349bac65e02ca23891507"
  license "AGPL-3.0"
  head "https://github.com/flok99/truncate.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "6608722fc6a0082220c5ea5b92abfe2753e5b11307f1d812cf79468456cfaa75"
    sha256 cellar: :any_skip_relocation, big_sur:       "114a1a8f6ad55877eed7574ee0e30c0f18535127ae173f55919fb0ead6c608cc"
    sha256 cellar: :any_skip_relocation, catalina:      "268e41b71c41a6d5297c7659061953053e2e833bde60d23ff80296950ff4f006"
    sha256 cellar: :any_skip_relocation, mojave:        "99e774220ef9a0cdb89f4300c671ac9eb74840cf5ed2d0731f12d20e680ff939"
    sha256 cellar: :any_skip_relocation, high_sierra:   "e1386eda3a93dddd528d1c3bf33b78c9c4da12039d7434b8db956e05eace9482"
    sha256 cellar: :any_skip_relocation, sierra:        "c4c892f0afbdf3a401ccb0af2a7cf8c65b37ccfdfe2412dda5284faa94f562ff"
    sha256 cellar: :any_skip_relocation, el_capitan:    "299b80454c20134c5d0916da25fb3d5f0b6843e620dac6babebe01a899253a69"
  end

  disable! date: "2022-07-31", because: :repo_removed

  conflicts_with "coreutils", because: "both install `truncate` binaries"
  conflicts_with "uutils-coreutils", because: "both install `truncate` binaries"

  def install
    system "make"
    bin.install "truncate"
    man1.install "truncate.1"
  end

  test do
    system "#{bin}/truncate", "-s", "1k", "testfile"
  end
end
