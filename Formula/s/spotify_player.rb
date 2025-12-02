class SpotifyPlayer < Formula
  desc "Command driven spotify player"
  homepage "https://github.com/aome510/spotify-player"
  url "https://github.com/aome510/spotify-player/archive/refs/tags/v0.21.2.tar.gz"
  sha256 "63fce17376105ba57a3a20d9e237141dfe655a4df606d6cd666a6cdd485f2f24"
  license "MIT"
  head "https://github.com/aome510/spotify-player.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b13ca4154ab22dcaa6c9a34d8e9bb9f658591341267b9aaf301a8874d67c79dd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5df5c88c62eedfbeae29d01102582ce2dfbb3a2ec130b9a0958fef46150237d0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cd03cdea9873f52598c37b73d2b90e9508bbce2aafccc3ef4a793917254707a1"
    sha256 cellar: :any_skip_relocation, sonoma:        "a6ea5f6a83548f10a43288d1eb1ef05d343be396119bc0c4d62b3d09d364fbdf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a01a292602a53fd702b4963e6d66174b07b25e2be87a27f8035041c3e8d3762b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fdaba6240962f29b3dd8faa7ef9e3e7a8168b62440dc72b6fef95d29ddcdd00e"
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
