class Webdis < Formula
  desc "Redis HTTP interface with JSON output"
  homepage "https://webd.is/"
  url "https://github.com/nicolasff/webdis/archive/refs/tags/0.1.24.tar.gz"
  sha256 "449ebbfa27c94e942fb2927c5d5a338456cbf8c7bafa00d6f6bd8ec45ad044a2"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "ca7f5b95b3e7aacec444a6c121da240705292adb581caa513ee0974405202c94"
    sha256 cellar: :any,                 arm64_sequoia: "114bca110c1b02371606f394cb06575a90ccc4b30d0294429f6914ae7cd1e588"
    sha256 cellar: :any,                 arm64_sonoma:  "6109f601d3c4c3f56279e24f50fd978f277cd70371e29a04f651aadd0d590d3c"
    sha256 cellar: :any,                 sonoma:        "135f913616b097726fe0611009e09902f58f7ef2e050c15d4a51f497d2d6f907"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2268b5724bac082669c0b9ddae7ecdcc45698ff77149d33c589017f3986896a3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4dec5745afcf7b2a2c0a74851b2b23b02665c911ab5271505516b69203582ca1"
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

    server = spawn bin/"webdis", "webdis.json"
    sleep 2
    # Test that the response is from webdis
    assert_match(/Server: Webdis/, shell_output("curl --silent -XGET -I http://localhost:#{port}/PING"))
  ensure
    Process.kill "TERM", server
    Process.wait server
  end
end
