class Webdis < Formula
  desc "Redis HTTP interface with JSON output"
  homepage "https://webd.is/"
  url "https://github.com/nicolasff/webdis/archive/0.1.21.tar.gz"
  sha256 "092ff00252d3cf589221f3b5ddcf3ab45a32c9a836ff9326cc3171cc3af76f30"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "136cb001fd37ba6099dfedb34ca4333e27d6f0a309fe7a9aeab1a08ab4c855fa"
    sha256 cellar: :any,                 arm64_monterey: "21314ccecf5bd171cb2c8e9ddf64534f2afd713225956953c510dc9bc6e7f173"
    sha256 cellar: :any,                 arm64_big_sur:  "68729233fb56d1b9143d666e85cfc7f8bad9c4346fd250180c1b8af3145b5134"
    sha256 cellar: :any,                 ventura:        "61da2c25a08d74d6f5da6469c7733093da61e633ba10957ac2864c8611392d03"
    sha256 cellar: :any,                 monterey:       "293b50fdf8ac6e6ee4d03a5c250b79f494a12d11a2588f85fb8ad8b10084b9b0"
    sha256 cellar: :any,                 big_sur:        "2675e00c484ac2ea9467b6ce5590abd552a108ebd270c4c65c946cc9ba38cf1c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e68b417a2d1a98fd90f2f9036aaea81254d488801348770a3e8f0805e8c9e60e"
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
