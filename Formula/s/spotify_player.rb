class SpotifyPlayer < Formula
  desc "Command driven spotify player"
  homepage "https://github.com/aome510/spotify-player"
  url "https://github.com/aome510/spotify-player/archive/refs/tags/v0.21.3.tar.gz"
  sha256 "1f7e42ebb340b7c83c0ab96a8ef21bce5acae9ef899ff9ecd377570fdd1f1dbe"
  license "MIT"
  head "https://github.com/aome510/spotify-player.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "53bd0d9e7b9c8addf705c01a80de51d3e732107dbe91837bd39b569aa5830a4f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "323862c14999bdb786e1eb32117e925d9f4b56294267827d021b6226f5c9ff9c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5d4bf1f1dbf60abbe30b5b56657a9244f2f9ce74a401b3f7cc58a83d245d81b4"
    sha256 cellar: :any_skip_relocation, sonoma:        "bc9ae5ed05e379bdff3d08c6ecced9b6dc61b2c81bda19277fbd7bb2186e1c24"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "971bea7084d2baf6dde28e72e6cbd67c818bd32707b11d5743ee32a346794775"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2f7df0bba6c7daaa41e3819407fc979116d459a156c03c6c30f6d74879a43f72"
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

    system "cargo", "install", "--features", "image,notify", *std_cargo_args(path: "spotify_player")
    bin.install "target/release/spotify_player"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/spotify_player --version")

    cmd = "#{bin}/spotify_player -C #{testpath}/cache -c #{testpath}/config 2>&1"
    _, stdout, = Open3.popen2(cmd)
    assert_match "https://accounts.spotify.com/authorize", stdout.gets("\n")
  end
end
