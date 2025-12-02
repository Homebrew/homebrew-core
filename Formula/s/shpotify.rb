class Shpotify < Formula
  desc "Command-line interface for Spotify on a Mac"
  homepage "https://harishnarayanan.org/projects/shpotify/"
  url "https://github.com/hnarayanan/shpotify/archive/refs/tags/2.1.tar.gz"
  sha256 "b41d8798687be250d0306ac0c5a79420fa46619c5954286711a5d63c86a6c071"
  license "MIT"
  head "https://github.com/hnarayanan/shpotify.git", branch: "main"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "a77b8a65c1e58b6bf20d640d688e62c01332f1663c7da3b37d7e0329280b4892"
  end

  def install
    bin.install "spotify"
  end

  test do
    system bin/"spotify"
  end
end
