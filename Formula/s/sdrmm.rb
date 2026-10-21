class Sdrmm < Formula
  desc "Modular, client-server software-defined radio"
  homepage "https://github.com/Newspicel/sdrminusminus"
  url "https://github.com/Newspicel/sdrminusminus/releases/download/v2.3.0/sdrmm-2.3.0-src.tar.gz"
  sha256 "3bf3742697bc63edc5a48ebbba94e104dc421c63e203dea4a44466671b2c03bf"
  license "AGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "4f34d4cc785ec278be08d7f80be4652e1711742f7cd9200fcef305b36f31d1b1"
    sha256 cellar: :any, arm64_tahoe:       "986784832d620886c6e7bb7ecb5821a4f7a96bd62b882ffded05ae011d18eef6"
    sha256 cellar: :any, arm64_sequoia:     "c4df3aea8fa432f7f8c517269d58d9c53e862645226710ca838bad83c0845683"
    sha256 cellar: :any, arm64_linux:       "f97da0e48f8cb21f55c46f4c0f6892da2fc622ab9a50bfb455abc227d4ae5dc7"
    sha256 cellar: :any, x86_64_linux:      "830ef2a860b28e3172ef8fbac70f8d28bdd4a27084309034e87bf291d754fac4"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "ffmpeg"

  uses_from_macos "llvm" => :build
  uses_from_macos "sqlite"

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
