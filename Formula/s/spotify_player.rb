class SpotifyPlayer < Formula
  desc "Command driven spotify player"
  homepage "https://github.com/aome510/spotify-player"
  url "https://github.com/aome510/spotify-player/archive/refs/tags/v0.19.1.tar.gz"
  sha256 "bd516ed91cee0a96444797c2b99f3775efea84c252f79f7bc7de4cdb33dbd52c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "76115237a91befd9ae3363ea43a25f202c4933c768d7655ae4befbdccee11e03"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3a7d1a7bc4ce2cff97a3b66e22f1ef665fed6e260e1b02478fa97844bcd0302b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1724139b95eccd702f51ef8ce7b49e35e2da55beb86b829ca09a9f44c5c27c27"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cff4ec347ded1f6687d1c0d7e5fed3f3e7db077b76bc59989b5396579f3843d0"
    sha256 cellar: :any_skip_relocation, sonoma:         "72c392c4cb1436f2cc09728ee40199122f0b63f2f3d8b584dbe81bc9b6fed584"
    sha256 cellar: :any_skip_relocation, ventura:        "d1774e20c830c57076b588ae3a9512161186625537bc84d1ea18952ea5e62d26"
    sha256 cellar: :any_skip_relocation, monterey:       "17f864490ae02502a76644d364699005e27bd6d377975216b5385207c99f9f06"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d7cf9752b98b9011e5e10b10c31da73899d184f908c104c4409ad585314e95d7"
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
