class Sdrmm < Formula
  desc "Modular, client-server software-defined radio"
  homepage "https://github.com/Newspicel/sdrminusminus"
  url "https://github.com/Newspicel/sdrminusminus/releases/download/v2.4.4/sdrmm-2.4.4-src.tar.gz"
  sha256 "d90b9d5cb4a665cf9f0125071652368ceb0a57225b0fb784bb207cedb7628b30"
  license "AGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "87c2352059327c2875b4d0faa362924f8e52d3e85da15b9c0181477e2597779e"
    sha256 cellar: :any, arm64_tahoe:       "f4a658da4e095835bf10ac8ec35ceaaac85a721b77321f9c0b7fe96bc0bf5b13"
    sha256 cellar: :any, arm64_sequoia:     "81a4f5b2c61343f575750053e348a2093d4b7a95b7219125c866e8b27ea54ed5"
    sha256 cellar: :any, arm64_linux:       "6d9bfc91a3ed8acc9764d64194751fadef03de639375b97fe92a689f9a69ab99"
    sha256 cellar: :any, x86_64_linux:      "b67852d0231180c02a449134d466253bf09e3365fbef442d7275e628d54c69d1"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "ffmpeg"

  uses_from_macos "llvm" => :build
  uses_from_macos "sqlite", since: :tahoe # requires sqlite3_set_clientdata

  # starts a server to test with
  allow_network_access! :test

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    ENV["LIBSQLITE3_SYS_USE_PKG_CONFIG"] = "1"
    system "cargo", "install", *std_cargo_args(path: "apps/sdrmm")
  end

  service do
    run [opt_bin/"sdrmm"]
    keep_alive true
    log_path var/"log/sdrmm.log"
    error_log_path var/"log/sdrmm.log"
  end

  test do
    assert_match(/\[ok\s*\] Device backends/, shell_output("#{bin}/sdrmm --doctor"))

    port = free_port
    pid = spawn bin/"sdrmm", "--bind", "127.0.0.1:#{port}"
    begin
      url = "http://127.0.0.1:#{port}"
      status = shell_output("curl -fsS --retry 30 --retry-delay 1 --retry-all-errors #{url}/api/status")
      assert_equal version.to_s, JSON.parse(status)["version"]
      assert_match '<div id="root"', shell_output("curl -fsS #{url}/")
    ensure
      Process.kill "TERM", pid
      Process.wait pid
    end
  end
end
