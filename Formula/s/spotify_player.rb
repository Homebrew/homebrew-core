class SpotifyPlayer < Formula
  desc "Command driven spotify player"
  homepage "https://github.com/aome510/spotify-player"
  url "https://github.com/aome510/spotify-player/archive/refs/tags/v0.25.1.tar.gz"
  sha256 "2f9f28e7ea74e14eb3be91d2655dd4666f2821cc58f74ec5db7640580e6a73bb"
  license "MIT"
  head "https://github.com/aome510/spotify-player.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "56638375d3ac6616a5be81b27a726bbea7c9365734199e4692bae279064312a6"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "781fd718e080d8349c4f7e760fa1bc01616a38bd9eef9e6a5d1788c34241ec9a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "fad9aad2bee2679bdad8bd4b6ee79e963b3be8b8f9ccd653ec5fb5a374398bf6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "a64e47465e70118cc48c18096b4d45ad4c237870bf04fc564aa49ec7bae98c14"
    sha256 cellar: :any,                 arm64_linux:       "f19543a544b7415dcc91719ff7a3aa7241ad2445aade31773673ea90fd142289"
    sha256 cellar: :any,                 x86_64_linux:      "0669a15a7e6d3ff1d567f19973d667b662d28e671f47692d491ede69feccd239"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "alsa-lib"
    depends_on "dbus"
    depends_on "openssl@3"
  end

  deny_network_access! :test

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = formula_opt_prefix("openssl@3")

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
