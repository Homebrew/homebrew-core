class Sdrmm < Formula
  desc "Modular, client-server software-defined radio"
  homepage "https://github.com/Newspicel/sdrminusminus"
  url "https://github.com/Newspicel/sdrminusminus/releases/download/v2.4.2/sdrmm-2.4.2-src.tar.gz"
  sha256 "ae5fd9397ac8ea330a999564828235fa44a02c641961ea4e573a5757f036f47d"
  license "AGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "57acf9e5f88d5cc625319de013e972ab81f13c2d600a826ffccf716d69eecd08"
    sha256 cellar: :any, arm64_tahoe:       "9c92c4fd5eae27fe9c8e3698263e47594e61058d9a2dd9426aa0da66545c675c"
    sha256 cellar: :any, arm64_sequoia:     "914d9eac1d071fe6e4588e5ed4b1d09f7cb1dad37eb61e0e7d7981ad4446c479"
    sha256 cellar: :any, arm64_linux:       "70e09f60ac3dbb59f5f9359df3a436331e1c3411ce8bb13616d4cbfa4a51e2b0"
    sha256 cellar: :any, x86_64_linux:      "253ebb036b1804f6b933e2a2b31939ed9f87261be037c2463ab0fa0f701d91b1"
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
