class SpotifyPlayer < Formula
  desc "Command driven spotify player"
  homepage "https://github.com/aome510/spotify-player"
  url "https://github.com/aome510/spotify-player/archive/refs/tags/v0.25.2.tar.gz"
  sha256 "60cc7cd60f66729039c0a48b134d8032c14817c88210d420722ad08340ad15cc"
  license "MIT"
  head "https://github.com/aome510/spotify-player.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "87de5d8f3d29149224ac39f04c1c1e7988cc1b98ab57e7dc97cc61b695015ae7"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "39105f6ba7355064d23f2764dbf6b58f23cb12c2c12faf716600ca47e5404e2b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "c48e80b40cf6489be7aeb8dae09499114f030604f9eefefe16225d3f41c3eb2b"
    sha256 cellar: :any,                 arm64_linux:       "0811b62641b633fab090151cfc7ed109b147b8798f6a739edc168222ce39707c"
    sha256 cellar: :any,                 x86_64_linux:      "f33a5f80811ad9b3a5a404656dc43646deab883e58374826d7da23c675755968"
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
