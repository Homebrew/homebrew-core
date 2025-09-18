class Snapcast < Formula
  desc "Synchronous multiroom audio player"
  homepage "https://github.com/badaix/snapcast"
  url "https://github.com/badaix/snapcast/archive/refs/tags/v0.32.3.tar.gz"
  sha256 "e53a62872d03521c7ce261378792f203d4073d769b362116ab02c98aa7c64008"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "ee9ba3f6a316f4d386abd8a84079a1425de2ba850641bae3065e65c5679331e7"
    sha256 cellar: :any,                 arm64_sequoia: "2cec9d7a9ec03701702d074652c9bbaaffa2fbda24a8a35a793ae8256918e5fe"
    sha256 cellar: :any,                 arm64_sonoma:  "8eb02f10ce66da4a08c25325ff3ad499aa90874ebe573cf12d31d114d32db3eb"
    sha256 cellar: :any,                 arm64_ventura: "37abe8373c9db62d0421afd78d5ca599483e9802f4ef61fc8672fdb09bec1319"
    sha256 cellar: :any,                 sonoma:        "6b4e2ca4f2d06746c9bdb153cd3c1a79be96f02bb280b0c822f9e205c693230d"
    sha256 cellar: :any,                 ventura:       "e45fbb627592bc990bb2b2f48b4a32d97d84050db8642a899b2041caf6c21f34"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5f0d76cb3b81547da814efa3ff5f34a17f48f6427325b7bbed8b355c89e263c4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3b770db41a025dd0d28dfba001db146150f654969f9cc61f853211b4897f1aff"
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
