class Snapcast < Formula
  desc "Synchronous multiroom audio player"
  homepage "https://github.com/snapcast/snapcast"
  url "https://github.com/snapcast/snapcast/archive/refs/tags/v0.35.0.tar.gz"
  sha256 "cb75a71479bf52910bf5f47ae8120ec41c89459b0d77d7cd560e674e437ef050"
  license "GPL-3.0-or-later"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "ff3736ac6d060aa12bb5f20c9bdff44eddf1599e4dbfae99cb62ca5d58cbecd0"
    sha256 cellar: :any,                 arm64_sequoia: "f029d457826ddc09f04d6a68a07ed0c7e08d2d19ec7afa1068b23ba824bc5d73"
    sha256 cellar: :any,                 arm64_sonoma:  "206de0dd3393237be71d89125b131f11797606aea872e413ed5c1877fe6508c6"
    sha256 cellar: :any,                 sonoma:        "5603fec33ba9ba3e83fb16d10423579f8b589f5c82290ae6e29097b70fe6e723"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ace3d2ab530a6c0312a13d815086d2b67c1230b01100119aef106102f8eb8427"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6037bb300c6c03217793eb4910b336939d3c5c27a0dbf1ee05b994308f42327c"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "pkgconf" => :build

  depends_on "flac"
  depends_on "libogg"
  depends_on "libsoxr"
  depends_on "libvorbis"
  depends_on "openssl@4"
  depends_on "opus"

  uses_from_macos "expat"

  on_linux do
    depends_on "alsa-lib"
    depends_on "avahi"
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
