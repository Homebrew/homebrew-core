class SpotifyPlayer < Formula
  desc "Command driven spotify player"
  homepage "https://github.com/aome510/spotify-player"
  url "https://github.com/aome510/spotify-player/archive/refs/tags/v0.14.1.tar.gz"
  sha256 "bf4c71d7942c2c660e06a95ecebefa312404ef84c36af894eedaef7ec39a7b41"
  license "MIT"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "196ce340c6f58bb7034b06bf0b306ee038c9c21ee82c6870ff4cbea24d813ccf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "df9ecc3b58f1ec556586f0ac2e01dde3090dcf92e5c618cd10bc1430af4c2858"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b16aafa97a32a56f44425154d6bbeefc852a2d9fc22f971781f985a816ee8b9d"
    sha256 cellar: :any_skip_relocation, ventura:        "40e04929614c395eeea74d6339d34baa78d1c220b9bd571205c89597b669145e"
    sha256 cellar: :any_skip_relocation, monterey:       "76edf4e5997fc28a5e2618d5eb714c485bd7be391248460522b6b318c010b5b2"
    sha256 cellar: :any_skip_relocation, big_sur:        "6469ec7ccce8f04866ebb5c8274a6bc6e741a667fce4cffbc7e49d51a0e15cc4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8866ee18a90757fe4a9e100ec0c9a7b839d7904a8379cdf7c541fdcae1b778ce"
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
