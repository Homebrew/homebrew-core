class SpotifyPlayer < Formula
  desc "Command driven spotify player"
  homepage "https://github.com/aome510/spotify-player"
  url "https://github.com/aome510/spotify-player/archive/refs/tags/v0.24.0.tar.gz"
  sha256 "aff7e5b8aa6efa00a51d82e9fe076aa3abc93e3b922682043b0ffe2909516f0f"
  license "MIT"
  head "https://github.com/aome510/spotify-player.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "85d178bcbcd676bbde8887a4d706961c5adef0911b9afa01336b65734de971a9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ee106a4a5e125fda0fd3b62b0e333baa25634142d978f10bbaf889019987df56"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "61fdc74421e4d7183de83d772e07aa1919148036f210514110bf0b30ad69704e"
    sha256 cellar: :any_skip_relocation, sonoma:        "d1cec79ce1b9905455f498a6e59b2330b5cacd8c4147c2c0c33e43d34ee837d3"
    sha256 cellar: :any,                 arm64_linux:   "6251898d5e9d7cd0a41436714e609f62607e4f5ed41fb2a2f72ea757cbcfafc0"
    sha256 cellar: :any,                 x86_64_linux:  "973c0a45cd518b3cc5ebe491940574bf0c5d387143c1fd7d153b6152538b3d12"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "alsa-lib"
    depends_on "dbus"
    depends_on "openssl@3"
  end

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = formula_opt_prefix("openssl@3")

    features = ["image", "notify"]
    system "cargo", "install", *std_cargo_args(path: "spotify_player", features:)
    bin.install "target/release/spotify_player"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/spotify_player --version")

    cmd = "#{bin}/spotify_player -C #{testpath}/cache -c #{testpath}/config 2>&1"
    _, stdout, = Open3.popen2(cmd)
    assert_match "https://accounts.spotify.com/authorize", stdout.gets("\n")
  end
end
