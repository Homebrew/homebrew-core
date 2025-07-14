class Spotifyd < Formula
  desc "Spotify daemon"
  homepage "https://spotifyd.rs/"
  url "https://github.com/Spotifyd/spotifyd/archive/refs/tags/v0.4.1.tar.gz"
  sha256 "fdbf93c51232d85a0ef29813a02f3c23aacf733444eacf898729593e8837bcfc"
  license "GPL-3.0-only"
  head "https://github.com/Spotifyd/spotifyd.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "a20d1e237ffc6f0fbe07af9641538c6059dff78030d3cdb537de1cc3a98c9abb"
    sha256 cellar: :any,                 arm64_sonoma:  "be5c9b8b6af3ef7eb0df00b4a1f0a46ba1016765eb97c32acf6f4881a9b1f72b"
    sha256 cellar: :any,                 arm64_ventura: "73e2515bec6b526ba93e57f45f90f856e3e32995748d7a31cfdda5b7046df583"
    sha256 cellar: :any,                 sonoma:        "853d77550839adae8fc9eb82bb0ec83e0fe423236b07a55fa7bca1d7e21de49a"
    sha256 cellar: :any,                 ventura:       "a4d68c08d9ab1e2206ccfe702f4074f70da3fbf5f0c52c69dd5e97595d91e7ac"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5286bb74874e724b27e03a9d23a618d644ed799bf10d930b2ed5a0298f4ad9ba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e667512a473240c05c0dc7f66bcde0258f511324a7b9fc07864089ab6ce3d399"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "dbus"
  depends_on "portaudio"

  def install
    ENV["COREAUDIO_SDK_PATH"] = MacOS.sdk_path_if_needed if OS.mac?

    system "cargo", "install", "--no-default-features",
                               "--features", "portaudio_backend",
                               *std_cargo_args
  end

  service do
    run [opt_bin/"spotifyd", "--no-daemon", "--backend", "portaudio"]
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
