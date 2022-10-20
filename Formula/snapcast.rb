class Snapcast < Formula
  desc "Synchronous multiroom audio player"
  homepage "https://github.com/badaix/snapcast"
  url "https://github.com/badaix/snapcast/archive/refs/tags/v0.26.0.tar.gz"
  sha256 "166353267a5c461a3a0e7cbd05d78c4bfdaebeda078801df3b76820b54f27683"
  license "GPL-3.0-or-later"
  revision 1

  bottle do
    sha256 cellar: :any, arm64_monterey: "43940265aea2debabe717648ef509c98aef3018290f57c4cb05c0e8567be1661"
    sha256 cellar: :any, arm64_big_sur:  "1a6d23f065fcfc38e6aa7fbfac653dd128b36a50dcc0f8c567e50ee0747bf6b8"
    sha256 cellar: :any, monterey:       "63b3f56b0521da50793dbd77c69075f5de6f7980d2249ddfe8fdf58a89e8a083"
    sha256 cellar: :any, big_sur:        "35633819e9b126ed8d5bc5508383706c373326be74b7ff1cb3168f27f8b59fcf"
    sha256 cellar: :any, catalina:       "385ab39a8af598fa27180b3c3d97161f1aad3cdb51aca3ce562366ce0be74928"
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
