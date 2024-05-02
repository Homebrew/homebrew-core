class SpotifyPlayer < Formula
  desc "Command driven spotify player"
  homepage "https://github.com/aome510/spotify-player"
  url "https://github.com/aome510/spotify-player/archive/refs/tags/v0.18.1.tar.gz"
  sha256 "2eb46b1fecbf076d40ee2747d703bc5ac0b9ec1d777b50506fe1c73961e308d1"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "05b904e7f385fa53666406e5cc85657af3f2033fd16a5095a5a2966e1c3c401d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9488dd6201f905bbe9f1e6833ae940066bbcbd6388968946ce36a7dda93d4660"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5c745b64af63ea1d28b9f34cb7f96a93a41ba9b0fa81c25b41628aeea0dd6469"
    sha256 cellar: :any_skip_relocation, sonoma:         "f767bf0cef691014c4c1c12b20b310af94919be5b54fbe19e755f90c7af8eb5a"
    sha256 cellar: :any_skip_relocation, ventura:        "761d95f6aeeb1a96a24edd74c835e70bfd7e3db0efeb6945c2f5836a82c20e9b"
    sha256 cellar: :any_skip_relocation, monterey:       "63378e5b2a0f9cea159819888ac6b27cba5bf2196856fc72c5d6e7d3792da629"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c751cde84862a435c84459737f7da214902767549d892bebe140ec5c50486d04"
  end

  depends_on "rust" => :build
  uses_from_macos "expect" => :test

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "alsa-lib"
    depends_on "dbus"
    depends_on "openssl@3"
  end

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    system "cargo", "install", "--features", "image,lyric-finder,notify", *std_cargo_args(path: "spotify_player")
    bin.install "target/release/spotify_player"
  end

  test do
    (testpath/"command.exp").write <<~EOS
      spawn #{bin}/spotify_player -C #{testpath}/cache -c #{testpath}/config
      expect {
        "Username:" { send "username\n" }
        default { exit 1 }
      }
      expect {
        "Password for username:" { send "password\n" }
        default { exit 1 }
      }
      expect {
        "Failed to authenticate" { exit 0 }
        default { exit 1 }
      }
      exit 1
    EOS

    system "expect", "-f", "command.exp"

    assert_match version.to_s, shell_output("#{bin}/spotify_player --version")
  end
end
