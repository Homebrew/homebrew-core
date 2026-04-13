class Snapcast < Formula
  desc "Synchronous multiroom audio player"
  homepage "https://github.com/snapcast/snapcast"
  url "https://github.com/snapcast/snapcast/archive/refs/tags/v0.35.0.tar.gz"
  sha256 "cb75a71479bf52910bf5f47ae8120ec41c89459b0d77d7cd560e674e437ef050"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d61c8d4bfd965dd2ddcbc77eb73e12a59aef21dd2835bbca7e8b246b110750f4"
    sha256 cellar: :any,                 arm64_sequoia: "dacaa2ae4beec81fafada1b9549b04b8bba3d6276827b7988844b1a6810e05f8"
    sha256 cellar: :any,                 arm64_sonoma:  "a9613d42b9eeafb28a03889f260adbc225865dca3715ddf8023a903e6fcbc807"
    sha256 cellar: :any,                 sonoma:        "14aa0fbaf99749b161e79b1f216d1e4396f550d8ed242733bc058e7eacb4528a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7e40d4b536ed307ff8f8982fbb660ef400444c5096f894834470c3596fcf4593"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cf3c9e17907d2351ada549641c22b570b970d35b46d41d6fc1e045dc50acf1f2"
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
