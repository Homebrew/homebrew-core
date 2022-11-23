class Webdis < Formula
  desc "Redis HTTP interface with JSON output"
  homepage "https://webd.is/"
  url "https://github.com/nicolasff/webdis/archive/0.1.20.tar.gz"
  sha256 "1f0c8e8e8b68486fb7ccfc68a2c0d28167f7b243004b8a521c2552d0f9bbbe84"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "72a5b658a3adfe30bceb5e169d3739c0241f19d92358b4adf670dbc265791c0e"
    sha256 cellar: :any,                 arm64_monterey: "01d68d884586fcc671ac5db5ee136eab325c122791193fae278ad6542f793ec7"
    sha256 cellar: :any,                 arm64_big_sur:  "e214f9eb12345cc5998c5e30930eb18b67751540e9be07c7cad9b466f91d147d"
    sha256 cellar: :any,                 ventura:        "e1b7ec93e73942bd6fa46bf5cb1eabb2dd14f54d55aacaca9a38a09d1fccd020"
    sha256 cellar: :any,                 monterey:       "25c756e3714e87f34fb9ba04f03c1ac06a905291a2d67460067f0c43c5965716"
    sha256 cellar: :any,                 big_sur:        "8121d9e66429ec5b2c94683c7781cbabfdde8c71a90e7a4b986f02bcc451ad53"
    sha256 cellar: :any,                 catalina:       "ec7bd136523ac94e2644d8d6f8e7e4d9f0163e733af9504ae0e7769906550835"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cd85baa15e4d7f640c83712d2e507683307fbd8df46257e8c38a59f6967263c5"
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
