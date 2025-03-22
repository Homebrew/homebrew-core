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
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia:  "dd6598774377cc653a1e34568c6afff11509e3fac350dc0084532ad1eaad97ec"
    sha256 cellar: :any,                 arm64_sonoma:   "a2305bcd95c814f04cf6bef9d9c01a2cd1b6ab1c3f0c9e2dc1cb6ee85f468556"
    sha256 cellar: :any,                 arm64_ventura:  "3237a0154b6fddbf87eaea3b4460c8a992b72217899637d479a31f2bcd7ba53e"
    sha256 cellar: :any,                 arm64_monterey: "25689c32e31f1b2990ffb54fe34ba61856951b8c81d09bea1a4cc4d02d8c6fd9"
    sha256 cellar: :any,                 sonoma:         "7f9e21a27e9b6af17a131d62c23758ba6e7649c9a8ef38bd51b63d7e76dbcbff"
    sha256 cellar: :any,                 ventura:        "af948d2987f9c1f31f7217981ab42a62356b51c6793dc4091005795a917845fb"
    sha256 cellar: :any,                 monterey:       "00d7a5bfb6a4b4cb59e52b6d154e7268b576ed255df3ac199eceed6e7f84ff26"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4baab23fe6181c526b89960d0fb9db63bafea067a4ac9c6f5ac6af658267eea9"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "dbus"

  on_macos do
    depends_on "portaudio"
  end

  on_linux do
    depends_on "alsa-lib"
    depends_on "pulseaudio"
  end

  def backend
    on_macos do
      return "portaudio"
    end
    on_linux do
      return "pulseaudio"
    end
  end

  def install
    ENV["COREAUDIO_SDK_PATH"] = MacOS.sdk_path_if_needed if OS.mac?

    # The same features as upstream's "default" feature set binaries
    # https://github.com/Spotifyd/spotifyd/blob/master/.github/workflows/cd.yml
    features = %w[dbus_mpris rodio_backend]
    features += if OS.mac?
      %w[portaudio_backend]
    else
      %w[alsa_backend pulseaudio_backend]
    end

    system "cargo", "install", "--no-default-features", "--features", features.join(","), *std_cargo_args

    inreplace "contrib/spotifyd.conf", /^#backend = "alsa"/, "backend = \"#{backend}\""
    etc.install "contrib/spotifyd.conf"
  end

  def caveats
    "The service's configuration can be modified at #{etc}/spotifyd.conf"
  end

  service do
    run [opt_bin/"spotifyd", "--no-daemon", "--config-path", etc/"spotifyd.conf"]
    keep_alive true
  end

  test do
    require "open3"

    port = free_port
    args = ["--no-daemon", "--use-mpris=false", "--backend=#{backend}", "--verbose", "--zeroconf-port=#{port}"]
    Open3.popen2e(bin/"spotifyd", *args) do |_, stdout_and_stderr, wait_thread|
      sleep 5
      Process.kill "TERM", wait_thread.pid
      output = stdout_and_stderr.read
      assert_match "Zeroconf server listening on 0.0.0.0:#{port}", output
      refute_match "ERROR", output
    end
  end
end
