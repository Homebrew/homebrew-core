class Snapcast < Formula
  desc "Synchronous multiroom audio player"
  homepage "https://github.com/badaix/snapcast"
  url "https://github.com/badaix/snapcast/archive/refs/tags/v0.33.0.tar.gz"
  sha256 "5da21ab4a609550308be389d6af628628a89b6beb1d6e996ad2e4960e8e36d1d"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "3d37d627aab2244ea9c63f890e77ceb48b8715e78c9d09e1c6d215d4b93abf4e"
    sha256 cellar: :any,                 arm64_sequoia: "4df996bd8edeafea7ed418f3e3b726999b2d0a1e7015b84d9597a9505e5e511b"
    sha256 cellar: :any,                 arm64_sonoma:  "a702f22f94c6fb70e281f9aa5b2e4498201628b5a9b9274f98f2dfa7c17e53e6"
    sha256 cellar: :any,                 sonoma:        "674e87d9652eef30c68a1a743f6f774be7f04cf9732b45611e4994cb028d1fa0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "72bd589f700c16f2bffa0565fd87b4b537e6542c214ba0a95db61f3352cb5d9e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8f9892083f3cd9337b05d1abc0db933641012355cc191ac11cc7b01f770113e2"
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
    server_pid = spawn bin/"snapserver"
    sleep 2

    begin
      output_log = testpath/"output.log"
      client_pid = spawn bin/"snapclient", [:out, :err] => output_log.to_s
      sleep 10
      if OS.mac?
        assert_match version.to_s, output_log.read
      else
        # Needs Avahi (which also needs D-Bus system bus) which requires root
        assert_match "BrowseAvahi - Failed to create client", output_log.read
      end
    ensure
      Process.kill("SIGTERM", client_pid)
    end
  ensure
    Process.kill("SIGTERM", server_pid)
  end
end
