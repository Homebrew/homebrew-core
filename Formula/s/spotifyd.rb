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
    sha256 cellar: :any,                 arm64_tahoe:   "a7a814a9c313572487129d39e54731bc17a195e4b682ae581602448272abcdd5"
    sha256 cellar: :any,                 arm64_sequoia: "dec0ea296e4ef77db7afcc84910deea38ef162f5cadbf2d7fc2d9986a4ca5458"
    sha256 cellar: :any,                 arm64_sonoma:  "d9d891fefbd148e3960824fc7924ed89b20d73e150adfdbc36265df529c487a2"
    sha256 cellar: :any,                 sonoma:        "a4a0e77cd126c0eb50988c3e3c2820e963cdf9b8fe0e7fe055fb21811a01ff6b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fbfca354719211a24866dd87ac33a343191cfa0a13ff8ba8a604a288a2df891c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aa79e425ff77b2ea640dff5d8eeeddb772bb42a39397ed111fecc59479027d25"
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
