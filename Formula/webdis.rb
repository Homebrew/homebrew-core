class Webdis < Formula
  desc "Redis HTTP interface with JSON output"
  homepage "https://webd.is/"
  url "https://github.com/nicolasff/webdis/archive/0.1.16.tar.gz"
  sha256 "7aa3b741ca44595cf8113b40a161aa8bf55a1ecf338af7d1d078337f9212e9a6"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "ceb0a4d0bb8e67399ba8c7f6fed1b3435bddf640f714340fab7c2a11dbf3f373"
    sha256 cellar: :any,                 big_sur:       "904aa896e27354330cfebd4054304ef91240396e579525d001ba32b26e4df0f9"
    sha256 cellar: :any,                 catalina:      "645f9bfd01e32888199dedde784e2cc580f35b867be8452f48eff3dd2cd28734"
    sha256 cellar: :any,                 mojave:        "7fda79301bd18193d8b9d16042299e309533eb50bd3fc03edafddbafa3890b27"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "252df9c420034e2cc7586c55a5d9ee6f4934c0f63835ff4dfd7eb53a2e359cce"
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
