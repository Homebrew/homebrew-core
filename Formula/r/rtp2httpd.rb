class Rtp2httpd < Formula
  desc "Multicast RTP/RTSP-to-HTTP converter with web player and status dashboard"
  homepage "https://rtp2httpd.com"
  url "https://github.com/stackia/rtp2httpd/archive/refs/tags/v3.15.3.tar.gz"
  sha256 "406bd58db75eae446100fdf1af63d63401065c460cdb74bb2d5622154b8ae737"
  license "GPL-2.0-only"
  head "https://github.com/stackia/rtp2httpd.git", branch: "main"

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
