class SpotifyPlayer < Formula
  desc "Command driven spotify player"
  homepage "https://github.com/aome510/spotify-player"
  url "https://github.com/aome510/spotify-player/archive/refs/tags/v0.20.6.tar.gz"
  sha256 "87c3529a5b711a9c79bb0bac21fb65d280eec943f836920e0c02e8d9d17c75dd"
  license "MIT"
  head "https://github.com/aome510/spotify-player.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b29072af6f892bf5c156551ac92d823204cf34137024d86be75a145c73baaf41"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2dd2785af41488c08eed187247656051fab705c72d2df7cae109ff5e94181a66"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "805bfdea0373bc37fe78750fcc5026e374a8455575403f76c489ec832a0a5b59"
    sha256 cellar: :any_skip_relocation, sonoma:        "67c03b93dfd7a4869d6e717cea28781aa6291139534a66a0e3db9d2ab8879493"
    sha256 cellar: :any_skip_relocation, ventura:       "f27d8bc5c69f8fa46ec45d6cdda4db87162fada5abe70af9268111ceebfea96e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "93c88a00979d5b2ff2dd4eea4d77ea4e2264791e7b67f7f50bcc04991d02c720"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7d84bbd36d50ea4c9e446dd75fe232ac9eefe7d70bb1070f076f3162f0adf67f"
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
