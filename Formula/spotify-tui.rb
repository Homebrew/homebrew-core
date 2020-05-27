class SpotifyTui < Formula
  desc "Terminal-based client for Spotify"
  homepage "https://github.com/Rigellute/spotify-tui"
  url "https://github.com/Rigellute/spotify-tui/archive/v0.19.0.tar.gz"
  sha256 "eb2c8e8cb5f7778755589eebab91118be6eaa33a2289b058007af11666bffb84"
  head "https://github.com/Rigellute/spotify-tui.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "358ad4bae54d211d8be22d5ca3f46a4b15ab4a99b88c46016c73a4522cf2d5ca" => :catalina
    sha256 "7bddf8a63a41404024495aa504a7a08829998b377a1f7e28814d4acb98df00a7" => :mojave
    sha256 "ea964c3ee56fa603461204e613c96c3733bf1c283199da1d5ecfcbcfef7bfdcf" => :high_sierra
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--locked", "--root", prefix, "--path", "."
  end

  test do
    pid = fork { exec "#{bin}/spt -c #{testpath/"client.yml"} 2>&1 > output" }
    sleep 2
    Process.kill "TERM", pid
    assert_match /Enter your Client ID/, File.read("output")
  end
end
