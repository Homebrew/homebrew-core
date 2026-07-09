class Webdis < Formula
  desc "Redis HTTP interface with JSON output"
  homepage "https://webd.is/"
  url "https://github.com/nicolasff/webdis/archive/refs/tags/0.1.25.tar.gz"
  sha256 "60dc5e876a1df74d83ce5db41f99c61e62f45fa5ea7dbfedde4b1c99530f8032"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "086d5ce5fefbe2b76d819f917bc4a924157e4b95bee9d364857bf87272f4f420"
    sha256 cellar: :any,                 arm64_sequoia: "6c348962e8ecbfcfbc52032a5b149f4b2ac407c5dbbeaf63a0dce90f206e6a8b"
    sha256 cellar: :any,                 arm64_sonoma:  "a9e8e4c1bc861226004596ce620aa310fe1c8077821303186e825399c526565d"
    sha256 cellar: :any,                 sonoma:        "2b6d33d09f60a3304174206bf7eed46607360b802bcf9c74e51547ebf7733623"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2cc0a82ee4b77804b7a46df1733c4638562c7c4979bcabd9ca5d0c37e3030b51"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "db3f743c3ae3dd1febe4ba34cffffa1713d4524eaf0b397091e7830939acc230"
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
