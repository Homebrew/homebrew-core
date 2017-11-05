class Shpotify < Formula
  desc "Command-line interface for Spotify on a Mac"
  homepage "https://harishnarayanan.org/projects/shpotify/"
  url "https://github.com/hnarayanan/shpotify/archive/2.0.0.tar.gz"
  sha256 "2eadc1f8740dfd6b58f85b8f4802396f0684687ac891a88626dd5d2d3fc6ba4c"
  head "https://github.com/hnarayanan/shpotify.git"

  bottle :unneeded

  def install
    bin.install "spotify"
  end

  test do
    system "#{bin}/spotify"
  end
end
