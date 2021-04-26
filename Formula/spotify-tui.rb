class SpotifyTui < Formula
  desc "Terminal-based client for Spotify"
  homepage "https://github.com/Rigellute/spotify-tui"
  url "https://github.com/Rigellute/spotify-tui/archive/v0.24.0.tar.gz"
  sha256 "c3da9eec76fe5387555b63ff7e4de8e0e4f5eba948af6df112e02cf8031519ee"
  license "MIT"
  head "https://github.com/Rigellute/spotify-tui.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "c970396f66b149b3c1d58f3bdf2cdf6d4f7b974473399c9be53b1f0f4258267f"
    sha256 cellar: :any_skip_relocation, big_sur:       "781396790a6006952bb22f17aa6b03f057c41ec6ecbb7c18156ad392c394bdb2"
    sha256 cellar: :any_skip_relocation, catalina:      "70ae2722b6dd2bb21d574117a74ecb7812899e418b2cfe9ab2fd23de2014cde5"
    sha256 cellar: :any_skip_relocation, mojave:        "544761e6ad0758c70e7e24e4b89b319776c973d2aac0bbdbedaa4fd677a2ed59"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "libxcb"
    depends_on "openssl@1.1"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    pid = fork { exec "#{bin}/spt -c #{testpath/"client.yml"} 2>&1 > output" }
    sleep 10
    assert_match "Enter your Client ID", File.read("output")
  ensure
    Process.kill "TERM", pid
    quiet_system "pkill", "-9", "-f", "spt"
  end
end
