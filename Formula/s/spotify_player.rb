class SpotifyPlayer < Formula
  desc "Command driven spotify player"
  homepage "https://github.com/aome510/spotify-player"
  url "https://github.com/aome510/spotify-player/archive/refs/tags/v0.15.2.tar.gz"
  sha256 "799319c79619fb900c9090a81c54df88685417b571e880bad758934f234e77c2"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "35cefeaea59f5737d9f3f253ce55ffdef0113237c7b544715d7701b8bf140759"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dc502c992989719eca18ba15a2004c849384851cc7bbd33a0bff6ffab99be938"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9e3556215c45750637a3a44dc1a21edda5d81bad65e0a6f2a1a017cbedfdd39e"
    sha256 cellar: :any_skip_relocation, sonoma:         "0586247e6215d35a7134ea4e351cb6adb2ae5e8a51417e0b1e6f2cf5fdc9022e"
    sha256 cellar: :any_skip_relocation, ventura:        "2674e16501d83e404bf77a1af7c960e285067c853e495aeb35575db8d9232daa"
    sha256 cellar: :any_skip_relocation, monterey:       "cc2382672492c6504657592987f5a6c39e94d587ef9664576015fd985368360a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9fc5d6ff03d562775a0f5617993f03f53f4dc0eca5b65c037ba94b2a8d8e5d05"
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
