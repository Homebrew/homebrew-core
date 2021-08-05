class Webdis < Formula
  desc "Redis HTTP interface with JSON output"
  homepage "https://webd.is/"
  url "https://github.com/nicolasff/webdis/archive/0.1.16.tar.gz"
  sha256 "7aa3b741ca44595cf8113b40a161aa8bf55a1ecf338af7d1d078337f9212e9a6"
  license "BSD-2-Clause"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_big_sur: "55b4ee33b5296bcd27b91585b3356b9d7737fb24f7cda5adfcc30a4e586ac246"
    sha256 cellar: :any,                 big_sur:       "e862565d496026523a3de7eee972498fb69de7af174f916e4782db1353f9aaba"
    sha256 cellar: :any,                 catalina:      "b3b426e26ae5aeb0be4655e8d606ec7296212c2571ea2c6addac82244f15d242"
    sha256 cellar: :any,                 mojave:        "5ccbedfbb540501c278e8924c49ed974b34491499785d1fca48f6ad33ae4bfa1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a0d186746de1c08d6501c30f699fb7d9ba31cd1bbf449ecb4e2ea4eba20d187b"
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
