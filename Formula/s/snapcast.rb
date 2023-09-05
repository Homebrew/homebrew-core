class Snapcast < Formula
  desc "Synchronous multiroom audio player"
  homepage "https://github.com/badaix/snapcast"
  url "https://github.com/badaix/snapcast/archive/refs/tags/v0.27.0.tar.gz"
  sha256 "c662c6eafbaa42a4797a4ed6ba4a7602332abf99f6ba6ea88ff8ae59978a86ba"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_ventura:  "5f8b48a023b44476b3616388c9b7e307a4faf9cf84c499ddb4a9005e2f0c4bda"
    sha256 cellar: :any, arm64_monterey: "2ad42c1d88a43a12d762d96edcda0606c5fda5bb70681eda149985697b11ab11"
    sha256 cellar: :any, arm64_big_sur:  "8588b358091d73a106db67279386ad7be95f3219daba2bfb5f1c9312b953b718"
    sha256 cellar: :any, ventura:        "2bbbca9b982f1fec1ddb0586432a2422de1a0e0da70aed728acc7b0606653c07"
    sha256 cellar: :any, monterey:       "618395d8c3fdcb4e12929e7dc9a1157a5c89f62c0ce064fc28866601097a49eb"
    sha256 cellar: :any, big_sur:        "ba8f8d14a4b66bc87a4158fbd91b6f043566a65be66bfbb8d16322589960d265"
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
