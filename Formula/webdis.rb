class Webdis < Formula
  desc "Redis HTTP interface with JSON output"
  homepage "https://webd.is/"
  url "https://github.com/nicolasff/webdis/archive/0.1.20.tar.gz"
  sha256 "1f0c8e8e8b68486fb7ccfc68a2c0d28167f7b243004b8a521c2552d0f9bbbe84"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "40a0b0c2b314516596d16c4ef37c36fa34efdf3ce452d50fd85e4483fb24e6a5"
    sha256 cellar: :any,                 arm64_big_sur:  "1546d2c7db2beb4447bad667dded47935af8a57491cab99291c129028dcaf0e6"
    sha256 cellar: :any,                 monterey:       "72dc23016a7d1d15f2e3d8012941d12b790db7842e83b732235a09950d58c034"
    sha256 cellar: :any,                 big_sur:        "43a32b3cec20bac3e721d5b16567c7dce0bb77f52be2ebd0d35405100345aa82"
    sha256 cellar: :any,                 catalina:       "11558b9866a0fff0a952353559309d942413e297c15c8803490668bbd1ce2320"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6e3e86a0841eaccc4f6516ed5c8f585b91d9b952ccb19b6caf5ba7a8fe591535"
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
