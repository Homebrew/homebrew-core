class SpotifyPlayer < Formula
  desc "Command driven spotify player"
  homepage "https://github.com/aome510/spotify-player"
  url "https://github.com/aome510/spotify-player/archive/refs/tags/v0.15.0.tar.gz"
  sha256 "95eb498d5fddb29001613c1288f68606064dab56f04ee451b57c0ce835706f2a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "78c79ddeddf8bc79d4fd1ea6008c5ab8d3f4737b92f1f4146b47849bfb70556b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3c725803cd4082fa89c3b2185c18e07d2b8c6390084a6e60855856692a23204b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "acf7fc2cc1b603e4efda700a199f14d6b587b5a99108bfe2d9b4b00ed7f5a00a"
    sha256 cellar: :any_skip_relocation, ventura:        "eb7abda31162a98cc9a9964e7865d085307b67197ecaee24322a1862e2d8b167"
    sha256 cellar: :any_skip_relocation, monterey:       "a64303c56d37ae2723d351af107de971fff9033db9a8b6b82ef9796258d1c296"
    sha256 cellar: :any_skip_relocation, big_sur:        "84ca5327ff59825e0f10ba9a25fb6501a20a466d3a56239b54aa47fae41f2058"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b695dc30dfa99631282d5bc1519aa4be02d20fdda8783ae479fa4da0c2cc18b4"
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
