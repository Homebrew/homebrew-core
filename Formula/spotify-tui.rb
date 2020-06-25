class SpotifyTui < Formula
  desc "Terminal-based client for Spotify"
  homepage "https://github.com/Rigellute/spotify-tui"
  url "https://github.com/Rigellute/spotify-tui/archive/v0.20.0.tar.gz"
  sha256 "ead7014a383625d133937d20184a0bf015bfb50d9ddde8779fad3841baba426b"
  head "https://github.com/Rigellute/spotify-tui.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "d66b24cf5897b25d8c8b5efc5d3dd9c7f292e7432c37639653fef1f59dca5cdb" => :catalina
    sha256 "06780fac000e4ead2a80b7a4df5196fbbc254f092dc8ccbac5d711fc8c0d33e9" => :mojave
    sha256 "faf0fbfa572f3e8458414c21fddc1bd36156f2330969b4860f044bfc320be665" => :high_sierra
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
