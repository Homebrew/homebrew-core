class SpotifyPlayer < Formula
  desc "Command driven spotify player"
  homepage "https://github.com/aome510/spotify-player"
  url "https://github.com/aome510/spotify-player/archive/refs/tags/v0.17.1.tar.gz"
  sha256 "eef29fe3f18d2cea26d0acf83b00bf24f1031f2a2b129abbdcb713f8372b43bf"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d02afd188f15d24a83b179971c2f02f43f8daffa393aeed90c171244a6b52dca"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1f387a47b51004a6f4e1dba1d6c038d08a40b94686f50d2d1c1da5ee39310411"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9ac160f6d09d7258687b5336afa83ccda226024bdbc223923f9d11c7c62f5859"
    sha256 cellar: :any_skip_relocation, sonoma:         "5f334a3978ec1e17a6a14ef8c16857498a91e3a414b2b2f746962c3e6b5c0c08"
    sha256 cellar: :any_skip_relocation, ventura:        "da596f306ceedf9233c75e51876b4c6d609d542c8f7691e52108b4da4fd543b2"
    sha256 cellar: :any_skip_relocation, monterey:       "b4a0b17634261a17f7ee2beaa9869d4d43dddb45c0e46bef88b42eb30b6433f9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eac8daef87b5b4828fa16ff8674c047ad2e20ede430e5bc7ad9cceabb10422a5"
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
