class Sdrmm < Formula
  desc "Modular, client-server software-defined radio"
  homepage "https://github.com/Newspicel/sdrminusminus"
  url "https://github.com/Newspicel/sdrminusminus/releases/download/v2.4.3/sdrmm-2.4.3-src.tar.gz"
  sha256 "393c0ca6659a89812b992547406994bbb2b3caed48113de389e4b42344737c03"
  license "AGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "d03df4b9b87c9b287e1227c1c3a41eb146161c0394f660d40b15e656156db0ac"
    sha256 cellar: :any, arm64_tahoe:       "4fa002abad61d8437559dd9511aa4343aa7a2bd8ecfecab61c4c0156c8d45d39"
    sha256 cellar: :any, arm64_sequoia:     "fe5ae1c3f5428ee96c72bc4e80392418a3c1205d69eb822b4d9a232654786fc1"
    sha256 cellar: :any, arm64_linux:       "fd12b2526a46163163ec02dcb4a403fd9a438af13d19cda6b0923dbedcf2ca5f"
    sha256 cellar: :any, x86_64_linux:      "d72f1b69661515ffd7847c4f61fde02c08c044182ee3cef919778e2ab1eda7fe"
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
