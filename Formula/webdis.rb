class Webdis < Formula
  desc "Redis HTTP interface with JSON output"
  homepage "https://webd.is/"
  url "https://github.com/nicolasff/webdis/archive/0.1.17.1.tar.gz"
  sha256 "9389a57d43e84cb52223c0f9e8eb405f12402e5b0601c26ac703b3182a7ed5be"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "fd9175f6b0e00b194c2f5e0ed74537fd58fccf3f9dce7596dd64e0b25a179c75"
    sha256 cellar: :any,                 big_sur:       "4ba6120d66fced473e1159c45396fc212aa8a3f5d2a028569d51c3da7d600b0a"
    sha256 cellar: :any,                 catalina:      "8f8eeb34606f5bdea30c8fc0f59bed112a8dde210c67f3988a25a70efe746c61"
    sha256 cellar: :any,                 mojave:        "89e7945a6c8ee43d7cdb2d5ca7b28c203aa7c1c2d49444c21696fb43ad3caa55"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f1f4d7f194c3f93a39d22a9db363d9f0488a5175ebaa21e54e30a494a4a239a3"
  end

  depends_on "libevent"

  def install
    system "make"
    bin.install "webdis"

    inreplace "webdis.prod.json" do |s|
      s.gsub! "/var/log/webdis.log", "#{var}/log/webdis.log"
      s.gsub!(/daemonize":\s*true/, "daemonize\":\tfalse")
    end

    etc.install "webdis.json", "webdis.prod.json"
  end

  def post_install
    (var/"log").mkpath
  end

  service do
    run [opt_bin/"webdis", etc/"webdis.prod.json"]
    keep_alive true
    working_dir var
  end

  test do
    port = free_port
    cp "#{etc}/webdis.json", "#{testpath}/webdis.json"
    inreplace "#{testpath}/webdis.json", "\"http_port\":\t7379,", "\"http_port\":\t#{port},"

    server = fork do
      exec "#{bin}/webdis", "#{testpath}/webdis.json"
    end
    sleep 0.5
    # Test that the response is from webdis
    assert_match(/Server: Webdis/, shell_output("curl --silent -XGET -I http://localhost:#{port}/PING"))
  ensure
    Process.kill "TERM", server
    Process.wait server
  end
end
