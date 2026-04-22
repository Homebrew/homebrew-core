class Spotifyd < Formula
  desc "Spotify daemon"
  homepage "https://spotifyd.rs/"
  url "https://github.com/Spotifyd/spotifyd/archive/refs/tags/v0.4.2.tar.gz"
  sha256 "e1dc21f806b205739e508bd567698657a47ca17eecb0f91d9320af5e74b8418a"
  license "GPL-3.0-only"
  head "https://github.com/Spotifyd/spotifyd.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "7a96191a408faceec7796bbfba1d97ee2942bca55eb8d7ac0ff6ab9787d416b3"
    sha256 cellar: :any,                 arm64_sequoia: "33c617c8539e24bb3a7c45be7c0692bef970a404e83be5184d23d4823c1cfabf"
    sha256 cellar: :any,                 arm64_sonoma:  "610bd336a831d480602b36f001c677b0a552007197e881ee9ce5aadcf30908ef"
    sha256 cellar: :any,                 sonoma:        "52d368c18164c7dc72aa2ae105a950d004d455766ccb911c4307d8c6b39f8934"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b28a83b3436945a5dfa81133c01f7c223f9ce435e761266bda7d473fcb804a90"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e9f561aafae2034b26dbb892fd0be032d0f704f1fcdf815a4207ad005c72db00"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_macos do
    depends_on "portaudio"
  end

  on_linux do
    depends_on "alsa-lib"
    depends_on "dbus"
    depends_on "openssl@3"
    depends_on "pulseaudio"
  end

  def install
    if OS.mac?
      ENV["COREAUDIO_SDK_PATH"] = MacOS.sdk_path_if_needed
      args = %w[--no-default-features]
      features = %w[portaudio_backend]
    end

    system "cargo", "install", *args, *std_cargo_args(features:)
  end

  service do
    run [opt_bin/"spotifyd", "--no-daemon", "--backend", OS.mac? ? "portaudio" : "pulseaudio"]
    keep_alive true
  end

  test do
    args = ["--no-daemon", "--verbose"]
    Open3.popen2e(bin/"spotifyd", *args) do |_, stdout_and_stderr, wait_thread|
      sleep 5
      Process.kill "TERM", wait_thread.pid
      output = stdout_and_stderr.read
      assert_match "Starting zeroconf server to advertise on local network", output
      refute_match "ERROR", output
    end
  end
end
