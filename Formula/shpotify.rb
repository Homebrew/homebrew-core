class Shpotify < Formula
  desc "Command-line interface for Spotify on a Mac"
  homepage "https://harishnarayanan.org/projects/shpotify/"
  url "https://github.com/hnarayanan/shpotify/archive/2.0.2.tar.gz"
  sha256 "29d420311569f9c63e43cb9bd499c4975724e6c13e47e317be1dd44c8bbd16a6"
  head "https://github.com/hnarayanan/shpotify.git"

  bottle :unneeded

  def install
    bin.install "spotify"
  end

  test do
    system "#{bin}/spotify"
  end
end
