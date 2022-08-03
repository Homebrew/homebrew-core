class Snapcast < Formula
  desc "Synchronous multiroom audio player"
  homepage "https://github.com/badaix/snapcast"
  url "https://github.com/badaix/snapcast/archive/refs/tags/v0.26.0.tar.gz"
  sha256 "166353267a5c461a3a0e7cbd05d78c4bfdaebeda078801df3b76820b54f27683"
  license "GPL-3.0-only"

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "flac"
  depends_on "libsoxr"
  depends_on "libvorbis"
  depends_on "opus"
  depends_on "pulseaudio"
  uses_from_macos "expat"

  on_linux do
    depends_on "alsa-lib"
    depends_on "avahi"
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
