class Snapcast < Formula
  desc "Synchronous multiroom audio player"
  homepage "https://github.com/badaix/snapcast"
  url "https://github.com/badaix/snapcast/archive/refs/tags/v0.29.0.tar.gz"
  sha256 "ecfb2c96a4920adc4121b1180b37bb86566c359914c14831c0abea4e65d23f92"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_sequoia:  "5d48a09b06c654f46ce0cfd7bd1251be0c37bba213114b2e917c1fe5f0777fbf"
    sha256 cellar: :any, arm64_sonoma:   "e076ca61d99aeddad5ab382e4f41065351cd22d56e109e60b0ccaf76efe94790"
    sha256 cellar: :any, arm64_ventura:  "365c1db7191bb5d2f70003ccc55145853432aac3f9bcd84e8e18dfe3ce9907bf"
    sha256 cellar: :any, arm64_monterey: "f8b852400170331a4fc74987f28014ce13e318efdf78cebf8dbac90750e65926"
    sha256 cellar: :any, sonoma:         "5f3f8d975856a3fca7883b19bd745b5e29f93c99caf2e23db942298a944abe9d"
    sha256 cellar: :any, ventura:        "13691ba0b30c5fb0c79e03ef74c58da3af7f8eca534a59b541714d1737b7bc9c"
    sha256 cellar: :any, monterey:       "f7d46b2c184101630b7f98a8b62f82f465bcf4a4a846756806530c339d9d7d19"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "flac"
  depends_on "libogg"
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
