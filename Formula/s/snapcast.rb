class Snapcast < Formula
  desc "Synchronous multiroom audio player"
  homepage "https://github.com/badaix/snapcast"
  url "https://github.com/badaix/snapcast/archive/refs/tags/v0.31.0.tar.gz"
  sha256 "d38d576f85bfa936412413b6860875ba3b462a8e67405f3984a0485778f2fdac"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_sequoia: "6b17c4eedd473db0afc71acd236274684301d5f2afd59a4ac3fcea1ac70e9fd3"
    sha256 cellar: :any, arm64_sonoma:  "9fb4e448fd43f004e193bc6d6329d5ceb20e7d2c9744dd63b344ef9727e9ad1a"
    sha256 cellar: :any, arm64_ventura: "397cdd8dd74abb4e6eaa1f9e79432c62916b26323e314b4846bf3239d4dd6080"
    sha256 cellar: :any, sonoma:        "c7df35a8fc084671ac76e12d9408d047f77bea3ef5da4cfd5ad5760495eb96ab"
    sha256 cellar: :any, ventura:       "273d7eb4aca4df0376c1ac091e764c25554eed4a2a1c252f70a30fa0eb2f5260"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "pkgconf" => :build

  depends_on "flac"
  depends_on "libogg"
  depends_on "libsoxr"
  depends_on "libvorbis"
  depends_on "openssl@3"
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

    sleep 10
    Process.kill("SIGTERM", client_pid)

    output = r.read
    r.close

    assert_match("Connected to", output)
  ensure
    Process.kill("SIGTERM", server_pid)
  end
end
