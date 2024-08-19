class Snapcast < Formula
  desc "Synchronous multiroom audio player"
  homepage "https://github.com/badaix/snapcast"
  url "https://github.com/badaix/snapcast/archive/refs/tags/v0.28.0.tar.gz"
  sha256 "7911037dd4b06fe98166db1d49a7cd83ccf131210d5aaad47507bfa0cfc31407"
  license "GPL-3.0-or-later"

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_sonoma:   "75e6de027292f02f8e07acfbb259c90d176b39af701c0f100c3d2b6b443fbc8e"
    sha256 cellar: :any, arm64_ventura:  "3a54d56492e2124f689368a6d49b03bdae36bd35e3b0ce4445157123821d7da9"
    sha256 cellar: :any, arm64_monterey: "e3985b051dba335a8a964ac76a431e44b4e120f02e3e1883b876606fa2494e7c"
    sha256 cellar: :any, sonoma:         "cecd4502e518a7aa0a0b1bc827bdee80d62318e26378e72e3d1a3e6a856c4916"
    sha256 cellar: :any, ventura:        "637e67d6f01ecf9e2fec50af36d101901ab7ae9c8f6d9ba80e3f61f80b501a1d"
    sha256 cellar: :any, monterey:       "878309f55ef6cc0322491dbf9f83713182a773b7d0dd6b0da828a6518e790230"
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
