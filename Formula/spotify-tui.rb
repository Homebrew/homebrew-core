class SpotifyTui < Formula
  desc "Terminal-based client for Spotify"
  homepage "https://github.com/Rigellute/spotify-tui"
  url "https://github.com/Rigellute/spotify-tui/archive/v0.25.0.tar.gz"
  sha256 "9d6fa998e625ceff958a5355b4379ab164ba76575143a7b6d5d8aeb6c36d70a7"
  license "MIT"
  head "https://github.com/Rigellute/spotify-tui.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4a77728312f2125fb93bc0dc06cb17060c76d68e3231659e77568d13c221b02a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4ef8afcda5e9fc500a7dd2abc77f3b49f7d7fca7ae1da4acb9b54d263bfa434b"
    sha256 cellar: :any_skip_relocation, monterey:       "fc563b4f11f97560987f4a1c8ad386ed03506ec1f5dcfa99c02092560a97c0ae"
    sha256 cellar: :any_skip_relocation, big_sur:        "b47628e9447d374a0687c4335ad4d3403bdb104a5014a97f90455b5cd43aaf1c"
    sha256 cellar: :any_skip_relocation, catalina:       "3dedb376c70bd12c90c328e0135e00251fa8f1a1f5abbd1755b1d547641945e7"
    sha256 cellar: :any_skip_relocation, mojave:         "8304187e14830a1e879563caab9de18b13eca95dc4a65de1da36179eafb887a6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ccfd440c8cf171b997b747f7a15ba272351cb3ed2101f05b08672bbd2a73ed1d"
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
    output = testpath/"output"
    fork do
      $stdout.reopen(output)
      $stderr.reopen(output)
      exec "#{bin}/spt -c #{testpath}/client.yml"
    end
    sleep 10
    assert_match "Enter your Client ID", output.read
  end
end
