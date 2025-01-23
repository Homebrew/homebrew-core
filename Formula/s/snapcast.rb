class Snapcast < Formula
  desc "Synchronous multiroom audio player"
  homepage "https://github.com/badaix/snapcast"
  url "https://github.com/badaix/snapcast/archive/refs/tags/v0.30.0.tar.gz"
  sha256 "c1e7f745275526a92b4797ca63bb5a8b8b558f8cb35c200e13097244db6c8a1c"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_sequoia: "5f31b68727ed72b25f68bb5c0597e21aa02b9c5ae122589d34f8b9ce87ed1f4f"
    sha256 cellar: :any, arm64_sonoma:  "909e2be4d7a59c0d984b74f6c3f190ad57f1106314b66eb998cc216f7965105b"
    sha256 cellar: :any, arm64_ventura: "05745379bd18636496b7074eb3f9bbd5f8328d9012a985dff877b341459acd0e"
    sha256 cellar: :any, sonoma:        "c973393e6c198ab2be70ad54decde560ebbf0880e5fc5f00ec622cc644f8543e"
    sha256 cellar: :any, ventura:       "4deac0a5e90d41a6d361a4684ebb1afb7b381cb21396b0f5b5d5536359616e58"
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
