class Spotifyd < Formula
  desc "Spotify daemon"
  homepage "https://github.com/Spotifyd/spotifyd"
  url "https://github.com/Spotifyd/spotifyd/archive/v0.3.4.tar.gz"
  sha256 "c14df2499fa192cae5b6ade16c5cea70d29a5e977928dab283fa1fc12a3184df"
  license "GPL-3.0-only"
  head "https://github.com/Spotifyd/spotifyd.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "b92d7d114bfe738a57c9c4284d6a312fd8f3ba2a0d44218020f3e5f716834b1a"
    sha256 cellar: :any,                 arm64_monterey: "f793e1e8cb7fd679cd5c9ec60cf73856ff5b9f7f4a76cf4b164cd92e0b0882e8"
    sha256 cellar: :any,                 arm64_big_sur:  "ccc7f7fe6e4ae88ae96ae74bf9baad7d47830be43402fb9d686ddfec8f0d59e5"
    sha256 cellar: :any,                 ventura:        "1d944210d57b183d8d2a2826789afb82421a95ef7437be9e69aa46daf550449e"
    sha256 cellar: :any,                 monterey:       "5d43646e1a07cd5d5f63c7c0e3de2715f4b628908d1d48da329b1b4a6fcaaf31"
    sha256 cellar: :any,                 big_sur:        "2e72cfea42555845a7fd16aef8bef293fca0156072cfab80e19ccd4c7d056596"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1636dfcdb9652e50f923dbc251dfb878dec8fddeef997beac892f41c436fc698"
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
    assert_match "Bad credentials", shell_output(cmd)
  end
end
