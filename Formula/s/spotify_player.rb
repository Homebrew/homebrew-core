class SpotifyPlayer < Formula
  desc "Command driven spotify player"
  homepage "https://github.com/aome510/spotify-player"
  url "https://github.com/aome510/spotify-player/archive/refs/tags/v0.22.1.tar.gz"
  sha256 "b09ae88647758003eb7c666d3c2f60e1ff7624a14f9e8244332afe2b46167c4f"
  license "MIT"
  head "https://github.com/aome510/spotify-player.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "31ed14265c054ef0a89fa4a37c5060db27f504e8f6c5497b0c379eca02ecbb70"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "85c1296e1e3e22bdfbc24c09d3b8ff3a890e766efcd4c293d1f699eb17f236ba"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "577df86c83270c9678ccc0d7fa85a0c221e8cba69f094a3a90e304f309bfcf12"
    sha256 cellar: :any_skip_relocation, sonoma:        "02ae4815fd6cf3fb23fd0eaba71e8b947143aa2c8e83c6cb9acdfad735a8c84e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a1e71a778dd27a24991a496beedb0e0447a6ceb9cfb3700917433ba904c69f90"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "012899c71ab30f0343d55d7f3227145391e86b20e1ddd02503d341737bed1134"
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
