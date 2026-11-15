class Rtp2httpd < Formula
  desc "Multicast RTP/RTSP-to-HTTP converter with web player and status dashboard"
  homepage "https://rtp2httpd.com"
  url "https://github.com/stackia/rtp2httpd/archive/refs/tags/v3.17.2.tar.gz"
  sha256 "ce866091321a0d69dff7e8f7dda5d68be94e901659ed7d2ff4896029c8200ee6"
  license "GPL-2.0-only"
  head "https://github.com/stackia/rtp2httpd.git", branch: "main"

  bottle do
    sha256 arm64_golden_gate: "0a5c8ccf2c236d874fbc2ee7aa978e45aa860667acab10521ff2270542f369c3"
    sha256 arm64_tahoe:       "82e40d2fe11c5350bfee687493453e116af38e840d524561476b7bf7084605ee"
    sha256 arm64_sequoia:     "d9e1f4b04ed160d2fb45adc74cabf0bf0c2520a731fa624276cb64d1e863c440"
    sha256 arm64_linux:       "ebba26587104316ef99fe165bef108e800960a0451b307b462150654cba1d511"
    sha256 x86_64_linux:      "1cbf9541b3c0b895db6bf24b9ce1944d87fd6eb26d904eae4d5627e3cd551001"
  end

  depends_on "cmake" => :build

  allow_network_access! :test

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
