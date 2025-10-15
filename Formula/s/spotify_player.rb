class SpotifyPlayer < Formula
  desc "Command driven spotify player"
  homepage "https://github.com/aome510/spotify-player"
  url "https://github.com/aome510/spotify-player/archive/refs/tags/v0.21.1.tar.gz"
  sha256 "f4679325c06967ce28a697f05d7ca181dbbd832b0aa2a1ca1ec41512157347b1"
  license "MIT"
  head "https://github.com/aome510/spotify-player.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9ee4dac23df79effc4643848479de4bdc8288f284a0a28df6f2a78a8530e2070"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5cc3e78272b743f0751490b54592f6d82ec7f963893f34fc802cb85aa4c4fafe"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "faeebf52e479194410086e92ca6b43a090f9c20a0ae26475edeb67ebf0ba23a5"
    sha256 cellar: :any_skip_relocation, sonoma:        "3127caed60e67f56412aea0520df2b09ec2323e464cf366c6d66d78af23a308b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7f8b11b75b6d2e44273d8850b37d9a1cde42933f60f92b052435138fd9cd7df9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b0e1319859690dacd175a27f275812da8364c2887ef54b0e658ef5f78d28b7c0"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "pulseaudio"
    depends_on "dbus"
    depends_on "openssl@3"
  end

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    if OS.linux?
      system "cargo", "install", "--no-default-features", "--features", "pulseaudio-backend,streaming,media-control,image,notify", *std_cargo_args(path: "spotify_player")
    else
      system "cargo", "install", "--features", "image,notify", *std_cargo_args(path: "spotify_player")
    end
    bin.install "target/release/spotify_player"
  end

  test do
    cmd = "#{bin}/spotify_player -C #{testpath}/cache -c #{testpath}/config 2>&1"
    _, stdout, = Open3.popen2(cmd)
    assert_match "No cached credentials found", stdout.gets("\n")
    assert_match version.to_s, shell_output("#{bin}/spotify_player --version")
  end
end
