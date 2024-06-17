class SpotifyPlayer < Formula
  desc "Command driven spotify player"
  homepage "https://github.com/aome510/spotify-player"
  url "https://github.com/aome510/spotify-player/archive/refs/tags/v0.18.2.tar.gz"
  sha256 "0af639cb1a4e489e02a9c112554fa85af41e14490c9a66725b1f9eb1a7f4cfd4"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4410213aa78e77032b6af759d3a3ddc3221906092ea806c382beb8431f6e883e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "415ab3bb67cccb01fcb54bf5dfd20fa41f78a63971c418e3d564deddb36f27a3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c6db09650a1b3971af78aaba874657438124059d8e09242cf8dbc775b5731012"
    sha256 cellar: :any_skip_relocation, sonoma:         "82fe059082d5436d0b9d35f7538ee403556443ddf5fde7b7087110d23b7aefea"
    sha256 cellar: :any_skip_relocation, ventura:        "5f210fb12c17e6616baec2cbff1b68faa7c49a20413038fe881bf5d5de98dd37"
    sha256 cellar: :any_skip_relocation, monterey:       "30a4b12d57c0f2813084400ec37241a7bb9a951a599d20967754c3839e5c48a5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ca7cb2455a5fcade3c426f9958833fb95b703fa432a8e1aa5d82026fbb4eaa2a"
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
