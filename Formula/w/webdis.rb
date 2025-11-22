class Webdis < Formula
  desc "Redis HTTP interface with JSON output"
  homepage "https://webd.is/"
  url "https://github.com/nicolasff/webdis/archive/refs/tags/0.1.23.tar.gz"
  sha256 "e482e7eb2f7ba453df87a893791948b1f7921e51c14838179bc680a5d1a2018c"
  license "BSD-2-Clause"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "62087345de921d60b2299cd9ee575187ccff7e30a253c241c22903297175276f"
    sha256 cellar: :any,                 arm64_sequoia: "6defb9b07385ddcec869ea600b6a018005b18c0b0b561409c1f3e430708c60a5"
    sha256 cellar: :any,                 arm64_sonoma:  "8f829fe011b08d4e0f6d7f211d0d0842e8ad088488a683fe7125bff05f1658ba"
    sha256 cellar: :any,                 sonoma:        "1ac5b717e0b555322d262561bbf1f7a23cb586be72967b9ef91496582018bdc1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d4c8683d5df1e10cfc4ae2d87a2b0fa315167d38410c4c06fe46435c47c02d64"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cdf61ea9001c741118e9629972014cab7b200c0ca8433e718906707a0715fed5"
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
