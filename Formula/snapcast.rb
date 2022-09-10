class Snapcast < Formula
  desc "Synchronous multiroom audio player"
  homepage "https://github.com/badaix/snapcast"
  url "https://github.com/badaix/snapcast/archive/refs/tags/v0.26.0.tar.gz"
  sha256 "166353267a5c461a3a0e7cbd05d78c4bfdaebeda078801df3b76820b54f27683"
  license "GPL-3.0-or-later"
  revision 1

  bottle do
    sha256 cellar: :any, arm64_monterey: "1d823dd68d442d23045e039425160c775a8c6657de72d80b2d1bbe6bce5ff785"
    sha256 cellar: :any, arm64_big_sur:  "e452f9e3d9699b193f2b408a7785c906ce1f5d4be4eda0515591bb83522210ee"
    sha256 cellar: :any, monterey:       "41cda7276d96a8d9dd684f3d768d2a30d0b8012f7d1308d1285946c98023eab4"
    sha256 cellar: :any, big_sur:        "25eef0d2541b08199edab11561bbe89539bb496dc9bb8ebd51eb67423fdf8374"
    sha256 cellar: :any, catalina:       "23fc1c6e73ce837277caabb003da8d3a2bc11a42e3d91ad181ddc9e4a2de434d"
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
