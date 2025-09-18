class SpotifyPlayer < Formula
  desc "Command driven spotify player"
  homepage "https://github.com/aome510/spotify-player"
  url "https://github.com/aome510/spotify-player/archive/refs/tags/v0.21.0.tar.gz"
  sha256 "a1bc03ff6b1788283a38808745098d551f0d86b87a2fffabc61ceaaa17cfa93d"
  license "MIT"
  head "https://github.com/aome510/spotify-player.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e9bb8edd88bd83e5653d386e494fcc6eb3f853a3cbeb1da61448842ef5dc4286"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "057103d284a60c72ddcf5cee6c4b0689d53bc768422382027a46d6122d64c347"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "105b83108a50ca0b9bb3bbdef8206e486656b05f64bc0d7c2067511e1f727bc1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b418acb0b9a81ad5355edadd83b266a836643a9356de18d976b21a420d6cc2e0"
    sha256 cellar: :any_skip_relocation, sonoma:        "3aa62586443ef835b630d677bb3e786cdf7af82c28537c52afe5b2df5772d411"
    sha256 cellar: :any_skip_relocation, ventura:       "a235bafd40fcaf89a2aae68affea4a5959323bfa62e76e0911866ce20be194f0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4340851d4ad892a509305e90004d65cbd1c0a8193a48663159f087e5847408c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "051ea8d82c4bd69ab493650002c1497c29df22ab03491cc17379f4bde4eca429"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "alsa-lib"
    depends_on "dbus"
    depends_on "openssl@3"
  end

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    system "cargo", "install", "--features", "image,notify", *std_cargo_args(path: "spotify_player")
    bin.install "target/release/spotify_player"
  end

  test do
    cmd = "#{bin}/spotify_player -C #{testpath}/cache -c #{testpath}/config 2>&1"
    _, stdout, = Open3.popen2(cmd)
    assert_match "No cached credentials found", stdout.gets("\n")
    assert_match version.to_s, shell_output("#{bin}/spotify_player --version")
  end
end
