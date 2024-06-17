class Snapcast < Formula
  desc "Synchronous multiroom audio player"
  homepage "https://github.com/badaix/snapcast"
  url "https://github.com/badaix/snapcast/archive/refs/tags/v0.28.0.tar.gz"
  sha256 "ce7edf2db19835c0c4c2bf47af3bc3088a4740144df10fead9e7fb2741b8b51e"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "80fb41b2e5b1d10cf211303256547290722181f29f31f27f3b2b61e90a96a53e"
    sha256 cellar: :any, arm64_ventura:  "fe61bdbb1751d70c806e04635b71b6ce703cc2139123ad77709a0e3e34b9c756"
    sha256 cellar: :any, arm64_monterey: "d43333c9aec68a7a71443dd5c7e626071a8a1bdade0f79dfe717314dd352ae4f"
    sha256 cellar: :any, sonoma:         "340b42091cd68a9cb2244a1ef28d2e324ccebe2dbb0d17f8f3a311f6f1df59af"
    sha256 cellar: :any, ventura:        "84ad5a9b29a5a85d5f35798953fba89f0eec23affaa6e4fffd9feadc75a59ad5"
    sha256 cellar: :any, monterey:       "706c5bc609b28c03fedfdfef35c6fa804f8797fa034966fa2e4031aed403c45a"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "flac"
  depends_on "libsoxr"
  depends_on "libvorbis"
  depends_on "opus"

  uses_from_macos "expat"

  on_linux do
    depends_on "alsa-lib"
    depends_on "avahi"
    depends_on "pulseaudio"
  end

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    # FIXME: if permissions aren't changed, the install fails with:
    # Error: Failed to read Mach-O binary: share/snapserver/plug-ins/meta_mpd.py
    chmod 0555, share/"snapserver/plug-ins/meta_mpd.py"
  end

  test do
    server_pid = fork do
      exec bin/"snapserver"
    end

    r, w = IO.pipe
    client_pid = spawn bin/"snapclient", out: w
    w.close

    sleep 5
    Process.kill("SIGTERM", client_pid)

    output = r.read
    r.close

    assert_match("Connected to", output)
  ensure
    Process.kill("SIGTERM", server_pid)
  end
end
