class Rtp2httpd < Formula
  desc "Multicast RTP/RTSP-to-HTTP converter with web player and status dashboard"
  homepage "https://rtp2httpd.com"
  url "https://github.com/stackia/rtp2httpd/archive/refs/tags/v3.17.1.tar.gz"
  sha256 "80a79f148f8a6fc412dcfe2d45b4b552869a4a98f21b3128eafe75933580a740"
  license "GPL-2.0-only"
  head "https://github.com/stackia/rtp2httpd.git", branch: "main"

  bottle do
    sha256 arm64_golden_gate: "34477769de722d1843291111fda61fe95a0378aca47b9b6cf3d1e7b2c42458c6"
    sha256 arm64_tahoe:       "7ef053b508c37f9e4f101a6b7bd966c3a8d564cdcdc48447ac36bb246e6b6d4e"
    sha256 arm64_sequoia:     "6b9873dd134c820ebdccaf95a541ac9f6afb86487c7d1419e9df3e11b37353a1"
    sha256 arm64_linux:       "b8aab95f2e86e0ea69524e10778f46f5f14c3dfad6f6bee0abaa6ed03a21bf6b"
    sha256 x86_64_linux:      "ed2f2a334e399a1521bdcf32ec0ce025cd9b92c4edc8e5b2b6c84a5931cf7aa0"
  end

  depends_on "cmake" => :build

  def install
    ENV["RELEASE_VERSION"] = version.to_s

    system "cmake", "-S", ".", "-B", "build",
                    "-DCMAKE_INSTALL_SYSCONFDIR=#{etc}",
                    "-DENABLE_AGGRESSIVE_OPT=ON",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    (var/"run").mkpath
  end

  service do
    run [opt_bin/"rtp2httpd", "--config", etc/"rtp2httpd.conf",
         "--pid-file", var/"run/rtp2httpd.pid"]
    keep_alive true
    log_path var/"log/rtp2httpd.log"
    error_log_path var/"log/rtp2httpd.log"
  end

  test do
    port = free_port
    pid = spawn bin/"rtp2httpd", "--noconfig", "--listen", "127.0.0.1:#{port}"
    sleep 2

    assert_match "rtp2httpd", shell_output("curl --silent http://127.0.0.1:#{port}/status")
  ensure
    if pid
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
