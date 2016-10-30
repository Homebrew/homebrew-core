class Shpotify < Formula
  desc "Command-line interface for Spotify on a Mac"
  homepage "https://harishnarayanan.org/projects/shpotify/"
  url "https://github.com/hnarayanan/shpotify/archive/1.2.0.tar.gz"
  sha256 "5de136b3f01d63de2677ed443f8b398c8add3e2e7343798dac3bec0dd6607955"
  head "https://github.com/hnarayanan/shpotify.git"

  bottle :unneeded

  def install
    bin.install "spotify"
  end

  test do
    system "#{bin}/spotify"
  end
end
