class Spotifyd < Formula
  desc "Spotify daemon"
  homepage "https://github.com/Spotifyd/spotifyd"
  url "https://github.com/Spotifyd/spotifyd/archive/refs/tags/v0.3.5.tar.gz"
  sha256 "59103f7097aa4e2ed960f1cc307ac8f4bdb2f0067aad664af32344aa8a972df7"
  license "GPL-3.0-only"
  head "https://github.com/Spotifyd/spotifyd.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "95e7793371f6653dd0bafcecbdc3a3ad9df502a1019911aceb2476f0de4f39d3"
    sha256 cellar: :any,                 arm64_ventura:  "c20ff1077a0340d3b3f8324bb0476a277e173a4454c9738b4d85d3864333ef8a"
    sha256 cellar: :any,                 arm64_monterey: "2cdbfff4f46c77b505cb10d50f7779baaf31682f34998d60a744c4ac902791f7"
    sha256 cellar: :any,                 arm64_big_sur:  "dd7e1f611771ad76903e7f9ab922d3ad8f01266390a0e28361e526a75fea58e8"
    sha256 cellar: :any,                 sonoma:         "c601ce737baf1da96f6ee4a94c8ee332e1eccaeb9521ca12b7f1d16e871b7bb7"
    sha256 cellar: :any,                 ventura:        "64249703160dc45cc48743e309d85165ce37cd220550fcbf1a460e221353d453"
    sha256 cellar: :any,                 monterey:       "464c5f5825b68ba8c81340314467d078537b8c72fe1a0176d6c671756b2f2b18"
    sha256 cellar: :any,                 big_sur:        "7ffffa9cb731bc19954c5c39163183aafd74cfc6aaedd7275ebf17ee8ce1bb62"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d34d078fa63f06d7ee94589559b01b92d50cd22ddc5425b3628512800e8e36ae"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "dbus"
  depends_on "portaudio"

  def install
    ENV["COREAUDIO_SDK_PATH"] = MacOS.sdk_path_if_needed if OS.mac?

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
