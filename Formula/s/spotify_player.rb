class SpotifyPlayer < Formula
  desc "Command driven spotify player"
  homepage "https://github.com/aome510/spotify-player"
  url "https://github.com/aome510/spotify-player/archive/refs/tags/v0.23.0.tar.gz"
  sha256 "19397e2bc685e18a702aab3796f35c69ab1dc6ea093a2623386749b0d1887be3"
  license "MIT"
  head "https://github.com/aome510/spotify-player.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e68b97b935b10d158a034c302d8d39126c96aa681696d7e9056fe10fbb0af97c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "da7d5ecff4d8b798ebd910d4833a63de31830a02751cf7e2010db146a3a454cd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ed37254eefca0aff98b0004cfa6ea71a825036e5b225aaee2b08ea7da1c8d499"
    sha256 cellar: :any_skip_relocation, sonoma:        "caba15b57d15c19477d63e1fa6d675639a39225619f47e96576439f4a0a8a13d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "da9eb275d75392705fbf1d48f026e167d2877319ca0211c5819f47943edee00c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e07623c21cb25f979c3d47f8c3f129a26defaaad97c949799ed2ceff984e0089"
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
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

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
