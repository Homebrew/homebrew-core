class SpotifyPlayer < Formula
  desc "Command driven spotify player"
  homepage "https://github.com/aome510/spotify-player"
  url "https://github.com/aome510/spotify-player/archive/refs/tags/v0.14.1.tar.gz"
  sha256 "bf4c71d7942c2c660e06a95ecebefa312404ef84c36af894eedaef7ec39a7b41"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "92150363d4939204ccf8ea481a484eae52934b24ad63f82e3f687794aad6f6cd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "71d3add997b990591fcfd531726b2c268495190670f249ea1e612fd73c91b4aa"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f70ad4dee1ba60eb02d2b4fff9d260787acdeb1c1a44eb48c89058e240d47b65"
    sha256 cellar: :any_skip_relocation, ventura:        "3c3e4c653b65c198ae7eb590d5042973a8871c5242e7cdcd03dc1ea0f2104d40"
    sha256 cellar: :any_skip_relocation, monterey:       "def72d530e6227dccf9734895bd5cf480b6924547e129d94331203047e6e2f97"
    sha256 cellar: :any_skip_relocation, big_sur:        "e421271b7c87d03331f786cadee40150786bd88d60c216fddf128c2b1e2a3a0e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "69af7c8188d98f4dadd07f9acfc9c519bf5be9b6567ee95ccda9e772f53ed76e"
  end

  depends_on "rust" => :build
  depends_on "openssl@1.1"
  uses_from_macos "expect" => :test

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "alsa-lib"
    depends_on "dbus"
  end

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = Formula["openssl@1.1"].opt_prefix
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
