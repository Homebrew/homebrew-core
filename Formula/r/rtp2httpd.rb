class Rtp2httpd < Formula
  desc "Multicast RTP/RTSP-to-HTTP converter with web player and status dashboard"
  homepage "https://rtp2httpd.com"
  url "https://github.com/stackia/rtp2httpd/archive/refs/tags/v3.16.0.tar.gz"
  sha256 "83ff812c5b454cf70057bd2b714c891c8650260d4092d6b86629e451fda57d26"
  license "GPL-2.0-only"
  head "https://github.com/stackia/rtp2httpd.git", branch: "main"

  bottle do
    sha256 arm64_tahoe:   "b99b2427a9aea636f9d5bbc0c41aca150491d720d92e5d26429b300829a0429d"
    sha256 arm64_sequoia: "9018ea24eb2214e35a4dd2e092b49cf9ed4e6edefee60af3966df6eb3525ec6c"
    sha256 arm64_sonoma:  "ef2e6626ba91596f778d5f15e5fc7aa0972c2998b11c6311371d1d668994fd4f"
    sha256 sonoma:        "bb4f84b6e69684fe7db2f874f95f6d89de1074592fc7f263fc4f22b22a3ba0b2"
    sha256 arm64_linux:   "a0bb72866857ec948f06d5c88483e21667580b553a11d679e48503294cd7b955"
    sha256 x86_64_linux:  "856a10e0b705c3b8c52cacedbdbc8d6efb206aa77150cecba3a8b1571ad4db30"
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
