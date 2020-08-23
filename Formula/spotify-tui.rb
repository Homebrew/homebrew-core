class SpotifyTui < Formula
  desc "Terminal-based client for Spotify"
  homepage "https://github.com/Rigellute/spotify-tui"
  url "https://github.com/Rigellute/spotify-tui/archive/v0.21.0.tar.gz"
  sha256 "f12103c592c49857ea97f78079a30f38c97d449879a9b71801ce406f2df67fee"
  license "MIT"
  head "https://github.com/Rigellute/spotify-tui.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "26e77cf5b03c45e0cb0b934e75d1de29869dacf0dcc59685550e62be2ea18ba6" => :catalina
    sha256 "ff8df87d5297146c8c7ed37c11c3fc5b36f463d5de442212c00fc48109f46d1d" => :mojave
    sha256 "a7634db723c15f57c783426b237fa90d478dbc77cf15cfef9efac6e9693a2bcd" => :high_sierra
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    pid = fork { exec "#{bin}/spt -c #{testpath/"client.yml"} 2>&1 > output" }
    sleep 2
    Process.kill "TERM", pid
    assert_match /Enter your Client ID/, File.read("output")
  end
end
