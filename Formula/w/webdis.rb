class Webdis < Formula
  desc "Redis HTTP interface with JSON output"
  homepage "https://webd.is/"
  url "https://github.com/nicolasff/webdis/archive/refs/tags/0.1.23.tar.gz"
  sha256 "e482e7eb2f7ba453df87a893791948b1f7921e51c14838179bc680a5d1a2018c"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "c95a32da381c41544226dc1fd87657235858a07f03ff55e593749eb0f8ab57b0"
    sha256 cellar: :any,                 arm64_sonoma:  "0a6778e26839e3df4ebdb775d33b9d6298dedadf96ef4f086b7e64b58ae14908"
    sha256 cellar: :any,                 arm64_ventura: "2831f7de16d9180de3842c6ecf9ae9a544c43b98d6d0a907a5328e140512f825"
    sha256 cellar: :any,                 sonoma:        "5aff42161b96307719332e86c69d1040a81dc9379d241a3e98f5b96fb70f1191"
    sha256 cellar: :any,                 ventura:       "02d02d3df326ee2c8862901d5cd044879f790fc297b9e0781d957e2218b0848f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4b8ef81d4472b731a184ada0e2ce7536a2a41fd732cb4f84b925629d067b4380"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "66888ace6f4c47250c02fbd671f06c0269779d5f2fae00ce9e6a2cb02ee72937"
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
    cp etc/"webdis.json", testpath/"webdis.json"
    inreplace "webdis.json", "7379", port.to_s

    server = fork do
      exec bin/"webdis", "webdis.json"
    end
    sleep 2
    # Test that the response is from webdis
    assert_match(/Server: Webdis/, shell_output("curl --silent -XGET -I http://localhost:#{port}/PING"))
  ensure
    Process.kill "TERM", server
    Process.wait server
  end
end
