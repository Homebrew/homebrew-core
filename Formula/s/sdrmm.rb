class Sdrmm < Formula
  desc "Modular, client-server software-defined radio"
  homepage "https://github.com/Newspicel/sdrminusminus"
  url "https://github.com/Newspicel/sdrminusminus/releases/download/v2.5.1/sdrmm-2.5.1-src.tar.gz"
  sha256 "3ef1e14488d184e8341efc0cba28e723c661b4b49d89a93da964f51c0c1a9fd5"
  license "AGPL-3.0-or-later"

  bottle do
    manifest_sha256 "8064c1315d2592f8d6f3a8a5e6f2dd547019a05a83523aaba41a5c0d492cd65a"
    sha256 cellar: :any, arm64_golden_gate: "ff5d23bd7e7c9bfccaa30ed9ad4f02cd295f05e2f3b6678560c649cc69345898"
    sha256 cellar: :any, arm64_tahoe:       "e9cc5c3c48fac3bfbf7bc0a63220a65209dbb8478814eecc138ac4a5cbaee1cd"
    sha256 cellar: :any, arm64_sequoia:     "0888b6b027fb442bd22d38fabaa3c341942e767e475f1f2546b97e430b08e83d"
    sha256 cellar: :any, arm64_linux:       "490b46fde66c861100ab7930cef781e6ea8fdb15789c3a986ff8a30941798c40"
    sha256 cellar: :any, x86_64_linux:      "a9d71fc44bac4194ecb9c830a4e015b94e75eaacb5b84d3f431364b42728ccf9"
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
