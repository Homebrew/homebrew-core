class Snapcast < Formula
  desc "Synchronous multiroom audio player"
  homepage "https://github.com/badaix/snapcast"
  url "https://github.com/badaix/snapcast/archive/refs/tags/v0.26.0.tar.gz"
  sha256 "166353267a5c461a3a0e7cbd05d78c4bfdaebeda078801df3b76820b54f27683"
  license "GPL-3.0-only"

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "flac"
  depends_on "libsoxr"
  depends_on "libvorbis"
  depends_on "opus"
  depends_on "pulseaudio"
  uses_from_macos "expat"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    # Needed to pass the audit
    system "chmod", "755", "#{share}/snapserver/plug-ins/meta_mpd.py" 
  end

  test do
    pid = fork do
      exec ("#{bin}/snapserver")
    end
    sleep 2
    output = shell_output("timeout 2 #{bin}/snapclient", 124)
    assert_match(/Connected to/m, output)
  ensure
    Process.kill("SIGTERM", pid)
  end
end
