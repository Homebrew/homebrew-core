class SpotifyPlayer < Formula
  desc "Command driven spotify player"
  homepage "https://github.com/aome510/spotify-player"
  url "https://github.com/aome510/spotify-player/archive/refs/tags/v0.20.5.tar.gz"
  sha256 "06a409144461fa965916d7d92817fda4be3801402eff8278a3fc7a38448d54e1"
  license "MIT"
  head "https://github.com/aome510/spotify-player.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "586d9cd1b5f25763d9707b1bbdf3d0db8ff9a907f1d9366d54f0e6d0057357fe"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a71e28d1925528ea43fe781886b60685f639c3c9b4dac8ae643d55dae84b06db"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b4c4842939847c22541616bd9e3e942c3e5a0c0aec3d78bc8332df8f652010e2"
    sha256 cellar: :any_skip_relocation, sonoma:        "fe4ce0b9f2eac32fc47b3f79c52ddf87f407e16c1e7cf2f1380043c7c7155a8b"
    sha256 cellar: :any_skip_relocation, ventura:       "bafdf2dad5b6648769ddb426204422a5228c9e8695fa56d39fc5abce66543915"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4335402911998567074f316703ecba218463d5e3bd647541919861c9edbdfa3c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d892b242d6d3ee55e3cccbc5026492f7876d14969c2556b7ef44d3e1decd5e40"
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
