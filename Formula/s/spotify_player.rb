class SpotifyPlayer < Formula
  desc "Command driven spotify player"
  homepage "https://github.com/aome510/spotify-player"
  url "https://github.com/aome510/spotify-player/archive/refs/tags/v0.25.2.tar.gz"
  sha256 "60cc7cd60f66729039c0a48b134d8032c14817c88210d420722ad08340ad15cc"
  license "MIT"
  head "https://github.com/aome510/spotify-player.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "ef0bdc1161439fcc3ea673b05f2928690e2c4e962abc17a5a4aa08346e9fb523"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "04917bcdbefe0824841fb8dd6bf067da00abffaa0e7b4c3840d3f94697998e9b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "e17806aa52cff776c7794e3904d0a8becbcc1587ed3fa39a44307c4a069c447f"
    sha256 cellar: :any,                 arm64_linux:       "4f7b26ff1f6d62d923b5502d705d2f8f1ed0909bae4698912bffbca5d658ac9d"
    sha256 cellar: :any,                 x86_64_linux:      "b49cf120c3cdf46df599e44ffe917f16d6959522a43951637e60151d7e73b9b4"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "alsa-lib"
    depends_on "dbus"
    depends_on "openssl@4"
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = formula_opt_prefix("openssl@4")

    features = ["image", "notify"]
    system "cargo", "install", *std_cargo_args(path: "spotify_player", features:)
    bin.install "target/release/spotify_player"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/spotify_player --version")

    assert_match "complete -F _spotify_player", shell_output("#{bin}/spotify_player generate bash")

    (testpath/"config/app.toml").write "client_id = 123\n"
    output = shell_output("#{bin}/spotify_player -C #{testpath}/cache -c #{testpath}/config 2>&1", 1)
    assert_match "invalid type: integer `123`, expected a string", output
  end
end
