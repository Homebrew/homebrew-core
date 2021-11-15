class Spotifyd < Formula
  desc "Spotify daemon"
  homepage "https://github.com/Spotifyd/spotifyd"
  url "https://github.com/Spotifyd/spotifyd/archive/v0.3.2.tar.gz"
  sha256 "d1d5442e6639cde7fbd390a65335489611eec62a1cfcba99a4aba8e8977a9d9c"
  license "GPL-3.0-only"
  head "https://github.com/Spotifyd/spotifyd.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 2
    sha256 cellar: :any,                 arm64_monterey: "1108e828b2ed18a151143e3dc3dacdc0460efce76f56eba5d50fdf60bfbe06ae"
    sha256 cellar: :any,                 arm64_big_sur:  "fe8f92ca3a00fc2b8dc28a6c6d868c49f0febbe26ad818755045af763102e04f"
    sha256 cellar: :any,                 monterey:       "0666848f95b581365fa2563736f2226ae55e6c169d4efd446c3bcebc2028525e"
    sha256 cellar: :any,                 big_sur:        "027e2994c8471dcde0b06ceda61c07166fa9083d3a08f4056ba986be37f21db0"
    sha256 cellar: :any,                 catalina:       "b2a8c0dffe45b557509e6a70a47d9cd96c6222cdd2ab2d44c7366806ba3d7721"
    sha256 cellar: :any,                 mojave:         "2c047d9f19710edd8795e14351e36aac051c5f9397e262f4199cf9beffe1483b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "804c7e8e5855f5082734c558606c650c6004ea4e9cfc11d342f5d802cca0c1b4"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "dbus"
  depends_on "portaudio"

  def install
    ENV["COREAUDIO_SDK_PATH"] = MacOS.sdk_path_if_needed
    system "cargo", "install", "--no-default-features",
                               "--features", "dbus_keyring,portaudio_backend",
                               *std_cargo_args
  end

  service do
    run [opt_bin/"spotifyd", "--no-daemon", "--backend", "portaudio"]
    keep_alive true
  end

  test do
    cmd = "#{bin}/spotifyd --username homebrew_fake_user_for_testing \
      --password homebrew --no-daemon --backend portaudio"
    assert_match "Authentication failed", shell_output(cmd, 101)
  end
end
