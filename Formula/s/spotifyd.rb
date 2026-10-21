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
    rebuild 2
    sha256 cellar: :any, arm64_golden_gate: "9ea10c41fa0b39188f05fb4c520d94bbfc32e368ff879efb68591da32782ab2d"
    sha256 cellar: :any, arm64_tahoe:       "3e9ed5d7b835838ee4b7d51f5bb21e2cdb7f621fc275749e644344a7a321fa9a"
    sha256 cellar: :any, arm64_sequoia:     "2af21b852dac007f969a09a5ac7341b9b6073f5afbdb4673cf4c7f909c1f0f9b"
    sha256 cellar: :any, arm64_linux:       "421eecefe5c859c647f32cc3e555a4b3c691d89d950f9fa138727f361de4eca0"
    sha256 cellar: :any, x86_64_linux:      "00c484f4da9e7067609a856b5778c467854f9aafd03dffd1e1f6d034237ad62f"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_macos do
    depends_on "portaudio"
  end

  on_linux do
    depends_on "alsa-lib"
    depends_on "dbus"
    depends_on "openssl@4"
    depends_on "pulseaudio"
  end

  # Apply dependabot PR to support OpenSSL 4
  patch do
    url "https://github.com/Spotifyd/spotifyd/commit/f6e60439a1c55d21e8889218f357c184de8b4362.patch?full_index=1"
    sha256 "b7833b0de5182694cf1f5473eed4d0af6d20cf0951bef95ffae750eef6ebcb4b"
    type :unofficial
    resolves "https://github.com/Spotifyd/spotifyd/pull/1417"
  end

  allow_network_access! :test

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    if OS.mac?
      ENV["COREAUDIO_SDK_PATH"] = MacOS.sdk_path
      args = %w[--no-default-features]
      features = %w[portaudio_backend]
    end

    system "cargo", "install", *args, *std_cargo_args(features:)
  end

  service do
    # Backend should be specified in officially documented config file
    run [opt_bin/"spotifyd", "--no-daemon"]
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
