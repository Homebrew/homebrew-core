class Sdrmm < Formula
  desc "Modular, client-server software-defined radio"
  homepage "https://github.com/Newspicel/sdrminusminus"
  url "https://github.com/Newspicel/sdrminusminus/releases/download/v2.5.1/sdrmm-2.5.1-src.tar.gz"
  sha256 "3ef1e14488d184e8341efc0cba28e723c661b4b49d89a93da964f51c0c1a9fd5"
  license "AGPL-3.0-or-later"

  bottle do
    manifest_sha256 "3d693451d61700739bf154af87ed81f7d023e0e909fb6e28374a90494ecf1a50"
    sha256 cellar: :any, arm64_golden_gate: "d19143471373282033fa7df5070fcc21b0232b0e82bc858148bafefad892e07f"
    sha256 cellar: :any, arm64_tahoe:       "c07938cd34045b38fcb59e4f6d86415a703718e9bf7efcc22cc2b76f057ed787"
    sha256 cellar: :any, arm64_sequoia:     "7b421814fd891d5a5ad6e678317a5e5a418df1c4614b729722e325228dd09af3"
    sha256 cellar: :any, arm64_linux:       "13a54086fa1588494d484bc467a05829a416b4cff636575549cb95fad77fb824"
    sha256 cellar: :any, x86_64_linux:      "3b60704b30d8f7f31496c4382a58f8f14758974b976897fdbd21b8c928de0a9a"
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
