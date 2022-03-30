class RetroshareService < Formula
  desc "RetroShare friend to friend communication headless service"
  homepage "https://retroshare.cc/"
  url "https://github.com/RetroShare/RetroShare/releases/download/v0.6.6/RetroShare-v0.6.6-497-g2b4e57133-homebrew.tar.gz"
  version "0.6.6-497-g2b4e57133-homebrew"
  sha256 "69d9df59ea2566692d8c7cc8015a9ab100ed2578282bf7ccf4899e4f331a57fe"
  license "AGPL-3.0-only"
  head "https://github.com/RetroShare/RetroShare.git", branch: "master"

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "python@3.9" => :build
  depends_on "rapidjson" => :build
  depends_on "miniupnpc"
  depends_on "openssl@1.1"
  depends_on "sqlcipher"
  depends_on "xapian"

  uses_from_macos "curl" => :test
  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  def install
    system "cmake", "-S", "retroshare-service", "-B", "builddir",
                    "-DRS_FORUM_DEEP_INDEX=ON",
                    "-DRS_MAJOR_VERSION=#{version.major}",
                    "-DRS_MINOR_VERSION=#{version.minor}",
                    "-DRS_MINI_VERSION=#{version.patch}",
                    "-DRS_EXTRA_VERSION=-497-g2b4e57133-homebrew",
                    "-DCMAKE_VERBOSE_MAKEFILE=ON",
                    *std_cmake_args
    system "cmake", "--build", "builddir"
    system "cmake", "--install", "builddir"
  end

  test do
    port = free_port

    pid = fork do
      exec "retroshare-service", "--jsonApiPort", port.to_s
    end
    sleep 3

    assert_match version.to_s, shell_output("curl http://127.0.0.1:#{port}/rsJsonApi/version")
    assert_match "locations", shell_output("curl http://127.0.0.1:#{port}/rsLoginHelper/getLocations")
    assert_match "Invalid", shell_output("curl http://127.0.0.1:#{port}/rsLoginHelper/createLocationV2")

  ensure
    Process.kill("TERM", pid)
    Process.wait pid
  end
end
