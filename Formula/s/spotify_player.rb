class SpotifyPlayer < Formula
  desc "Command driven spotify player"
  homepage "https://github.com/aome510/spotify-player"
  url "https://github.com/aome510/spotify-player/archive/refs/tags/v0.20.4.tar.gz"
  sha256 "1d13f47ef4df3415835736f32629d57e331707d781507007ea04217a7dc735d8"
  license "MIT"
  head "https://github.com/aome510/spotify-player.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4d4c209c2b1b2872394ca7710af9844a076589a82539ec1af10396e7d0dd645c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3b1c0d92ca18821be8c48b28cdc2118ff836171cb22b605f8eb8360dd86e2430"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2f72e6181aa47f86f955a35bf47f54281e9ba4f8e575a408418e84d63a8de9e8"
    sha256 cellar: :any_skip_relocation, sonoma:        "d27c32ee622146d6c4fd6bc1a05fa266db4d507b8b5701beebce517e9288a7d9"
    sha256 cellar: :any_skip_relocation, ventura:       "b086dc07d207b7cb486fa068e0cdb3531cd31fa19184dd676a755ba9bd384f3c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "620f3f2a17f95b67c45f48a9e4d38b52dcefb184e01ad24c7929c79386c5d4a0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "57b865bf6b50b69d77b01d2717ea667f3a7b6f45c8b8d1f2dd84b23e29270705"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "pkgconf" => :build
    depends_on "alsa-lib"
    depends_on "dbus"
    depends_on "openssl@3"
  end

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    system "cargo", "install", "--features", "image,notify", *std_cargo_args(path: "spotify_player")
    bin.install "target/release/spotify_player"
  end

  test do
    cmd = "#{bin}/spotify_player -C #{testpath}/cache -c #{testpath}/config 2>&1"
    _, stdout, = Open3.popen2(cmd)
    assert_match "No cached credentials found", stdout.gets("\n")
    assert_match version.to_s, shell_output("#{bin}/spotify_player --version")
  end
end
