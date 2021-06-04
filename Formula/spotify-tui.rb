class SpotifyTui < Formula
  desc "Terminal-based client for Spotify"
  homepage "https://github.com/Rigellute/spotify-tui"
  url "https://github.com/Rigellute/spotify-tui/archive/v0.24.0.tar.gz"
  sha256 "c3da9eec76fe5387555b63ff7e4de8e0e4f5eba948af6df112e02cf8031519ee"
  license "MIT"
  head "https://github.com/Rigellute/spotify-tui.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "f8b013d72cb7c6345a0d2223a30911f94fb1a553de887dc0d339e26f0d5e89db"
    sha256 cellar: :any_skip_relocation, big_sur:       "23afc6b7fa6b41f7904ff988fb4e8d4c833ff422382867a49dce42b23a980a33"
    sha256 cellar: :any_skip_relocation, catalina:      "10f47a62a67d0d15dbdad33139c6723c278d698d19386e0a7c5b125eb0200116"
    sha256 cellar: :any_skip_relocation, mojave:        "ca1264421f176b28c06b197e40fce0f815ea292141b28ceb119bb5ecfdc38c7c"
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
