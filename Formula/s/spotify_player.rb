class SpotifyPlayer < Formula
  desc "Command driven spotify player"
  homepage "https://github.com/aome510/spotify-player"
  url "https://github.com/aome510/spotify-player/archive/refs/tags/v0.17.1.tar.gz"
  sha256 "eef29fe3f18d2cea26d0acf83b00bf24f1031f2a2b129abbdcb713f8372b43bf"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "eb58650767f3ccec6ba8c33a07de9449ba07852b6fbe469d7e7b6e68959cd8eb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "34deb627aaf74ae1f7b27d4523452ae58f221014d635c4f2b60276bc2ea9fe23"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "66780ef0924013cf2b5dded015e0013fdb8feccf9e0748b5ec49af60e7c25936"
    sha256 cellar: :any_skip_relocation, sonoma:         "77a254d3d9e7018a036d7408a2d67b7004ff598c33129f141af91bedc925077e"
    sha256 cellar: :any_skip_relocation, ventura:        "1ba4708103ddcd601cb827f15629cb8c02fbf53ce0a59d67bc93708968066094"
    sha256 cellar: :any_skip_relocation, monterey:       "31fef61b565d4d428e4cb029e335b2c0e7d587934f90c5b09fa63ff35fd2f88a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8b9ae5cb21327ba0371a3fb79025dee3a6ee190042241ef486ad64ceef5b1df5"
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
