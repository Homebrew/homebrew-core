class Shpotify < Formula
  desc "Command-line interface for Spotify on a Mac"
  homepage "https://harishnarayanan.org/projects/shpotify/"
  url "https://github.com/hnarayanan/shpotify/archive/1.1.0.tar.gz"
  sha256 "825de0c1100b3f596e635765b02f65c73919a26990d5d4520e87afea45147987"
  head "https://github.com/hnarayanan/shpotify.git"

  bottle :unneeded

  def install
    bin.install "spotify"
  end

  test do
    system "#{bin}/spotify"
  end
end
