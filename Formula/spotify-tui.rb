class SpotifyTui < Formula
  desc "Terminal-based client for Spotify"
  homepage "https://github.com/Rigellute/spotify-tui"
  url "https://github.com/Rigellute/spotify-tui/archive/v0.23.0.tar.gz"
  sha256 "836a686c78599431b7e4dcf4a2830d16b25d28bdc4f35d79f0d5e8c000788da7"
  license "MIT"
  head "https://github.com/Rigellute/spotify-tui.git"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "9d316a5047e3b4f5b398fb76ae05dc8bcc227976712127a5bdb7172086022217" => :big_sur
    sha256 "73b04f1272c318a17d60cd686e8bd40a911a929321cb0ba0d46277b98af4f3c4" => :arm64_big_sur
    sha256 "5fb0e8a727a268fab75e58a8be2643867cfc7a5e3af72003b94c64bd6caa2074" => :catalina
    sha256 "b4872366c45c70ef9104b2f5c07905615cf5726a1aa634fd9c80d4f05d8409e8" => :mojave
    sha256 "17e97d214e6e9220531cf22b2e8595bcfc0639cd373470a39077c79922d7ea2a" => :high_sierra
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
