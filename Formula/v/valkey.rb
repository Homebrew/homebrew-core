class Valkey < Formula
  desc "High-performance data structure server that primarily serves key/value workloads"
  homepage "https://valkey.io"
  url "https://github.com/valkey-io/valkey/archive/refs/tags/9.1.2.tar.gz"
  sha256 "19c23908e7d57e8d91ef85b41f5646307582f10f4f0fb999bbf89ed24ec9c983"
  license all_of: [
    "BSD-3-Clause",
    "BSD-2-Clause", # deps/jemalloc, deps/linenoise, src/lzf*
    "BSL-1.0", # deps/fpconv
    "MIT", # deps/lua
    any_of: ["CC0-1.0", "BSD-2-Clause"], # deps/hdr_histogram
  ]
  head "https://github.com/valkey-io/valkey.git", branch: "unstable"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "a6e719d537a9fa42f7e97f51dc1c10345a95727097ff45f0cfddc77981328279"
    sha256 cellar: :any, arm64_tahoe:       "a746f300d368d3ee99deb2a4fa75462a0d042c2f6fe87be4146bc0b8b7a24a93"
    sha256 cellar: :any, arm64_sequoia:     "f4c76aacd3e201ff73c11b7789f3ed9825688bd5ff13cd214b535eff648268d5"
    sha256 cellar: :any, arm64_sonoma:      "7445bef871f00c179f49a4f674ae3a2108ee5a322a185b5f525254e5f9ce7a56"
    sha256 cellar: :any, arm64_linux:       "ba3807aa5e6479aaa550809c0dfae7f2b1234561af9981bbdb26ae5eeac8760c"
    sha256 cellar: :any, x86_64_linux:      "3f3fb3b5a57b1fd215dc80cfc3d9eab1f5374e833b09e51c0026c5e374857a69"
  end

  depends_on "openssl@3"

  conflicts_with "redis", because: "both install `redis-*` binaries"

  def install
    system "make", "install", "PREFIX=#{prefix}", "CC=#{ENV.cc}", "BUILD_TLS=yes"

    %w[run db/valkey log].each { |p| (var/p).mkpath }

    # Fix up default conf file to match our paths
    inreplace "valkey.conf" do |s|
      s.gsub! "/var/run/valkey_6379.pid", var/"run/valkey.pid"
      s.gsub! "dir ./", "dir #{var}/db/valkey/"
      s.sub!(/^bind .*$/, "bind 127.0.0.1 ::1")
    end

    etc.install "valkey.conf"
    etc.install "sentinel.conf" => "valkey-sentinel.conf"
  end

  service do
    run [opt_bin/"valkey-server", etc/"valkey.conf"]
    keep_alive true
    error_log_path var/"log/valkey.log"
    log_path var/"log/valkey.log"
    working_dir var
  end

  test do
    system bin/"valkey-server", "--test-memory", "2"
    %w[run db/valkey log].each { |p| assert_path_exists var/p, "#{var/p} doesn't exist!" }
  end
end
