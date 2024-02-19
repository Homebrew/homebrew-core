class SpotifyPlayer < Formula
  desc "Command driven spotify player"
  homepage "https://github.com/aome510/spotify-player"
  url "https://github.com/aome510/spotify-player/archive/refs/tags/v0.16.3.tar.gz"
  sha256 "a36d042be08465344edc0268de9f46d269d30d79c420d04eb26d2d4ce56bf3aa"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c09131de5684ea4e297c598c6d909ffe275c98af09a8b59153fe0f8f908db7d4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "83f12fecf4a0bb55c5afb03df765901f910a4be7673a3bb8c446458070068cc8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "29782f268c605cb9006a05af7bf14d5eb05163d17aacde52d4db114a18ca81e8"
    sha256 cellar: :any_skip_relocation, sonoma:         "12d5995873ce8ba2acac611424c15ce4f998aa6c723cfdee462c8e6e8d03f777"
    sha256 cellar: :any_skip_relocation, ventura:        "cef637d7204ed8dcf1f6289226fd4e6d38851df888d6b18ac00f20feac551c43"
    sha256 cellar: :any_skip_relocation, monterey:       "94ed00c10285c8aa1f362b5f8f302625bf21727cee1df09b5c28ab8652005932"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f9acbf735e43a0c6e7347bf710b9b5da3ef3f583ee114617310c32dd017fac2b"
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
