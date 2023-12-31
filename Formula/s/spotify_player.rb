class SpotifyPlayer < Formula
  desc "Command driven spotify player"
  homepage "https://github.com/aome510/spotify-player"
  url "https://github.com/aome510/spotify-player/archive/refs/tags/v0.16.2.tar.gz"
  sha256 "1e956901b844e7aa104b671d1748f4e11e757e9da7a55fba913c68bf37becc3f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8f3b64f97025131e9112a25d90c37d75f0c31f721d493c5ecf2bec084571afe9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d80de3f3f19d47ff9dff3ed797ff5be3602bd05300b718b451458308ac09af68"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "61d0c62903b53af694dcf50bcda76ddae763827e9a3ff91d57b50d510c8edebd"
    sha256 cellar: :any_skip_relocation, sonoma:         "0456af222b07f734fafe678fdb6be814cb716878848ce9eab7f130d683cc754e"
    sha256 cellar: :any_skip_relocation, ventura:        "3188bee9ffdcbe801211dd31b8fc15a11fd3ca7543b342b74dcb5f8e2a3c7caa"
    sha256 cellar: :any_skip_relocation, monterey:       "03aa1d1d84cc4f5328bd28b48ceccd10fd8a3ac91b72bc8ea96a864ef4ae3b22"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2dc3745fd87bd415f408ae4dff9380b8d21cd4f674bab6c5f51e2c2da637ad21"
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
