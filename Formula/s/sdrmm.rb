class Sdrmm < Formula
  desc "Modular, client-server software-defined radio"
  homepage "https://github.com/Newspicel/sdrminusminus"
  url "https://github.com/Newspicel/sdrminusminus/releases/download/v2.4.2/sdrmm-2.4.2-src.tar.gz"
  sha256 "ae5fd9397ac8ea330a999564828235fa44a02c641961ea4e573a5757f036f47d"
  license "AGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "bc1c3fe488865a9a19a42a5293ba529219c735bd21a07fd97ed23283e7823a7d"
    sha256 cellar: :any, arm64_tahoe:       "93005860336e1a04e8c6c008fe36d79e4935a71dd3e241089c40aa3c32a2c72b"
    sha256 cellar: :any, arm64_sequoia:     "d38b4ff5e3e6e615f0c8fa5406f48d928aa03eb894ba930a0fc26246ea6344f4"
    sha256 cellar: :any, arm64_linux:       "84566e5daac497d3fb4d0bf45810fdbf38ab6474515cd6498e722a08f32c925a"
    sha256 cellar: :any, x86_64_linux:      "094bf8a17df2c17089f25e26eacd51d871dbd71f2c47821c1f7e148e1f5a5f3c"
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
