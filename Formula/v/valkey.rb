class Valkey < Formula
  desc "High-performance data structure server that primarily serves key/value workloads"
  homepage "https://valkey.io"
  url "https://github.com/valkey-io/valkey/archive/refs/tags/9.2.1.tar.gz"
  sha256 "fec5d34ac6f5c7f35cddcaae368734d8a789f1af2f7c29853e790f093d848d71"
  license all_of: [
    "BSD-3-Clause",
    "BSD-2-Clause", # deps/jemalloc, deps/linenoise, src/lzf*
    "BSL-1.0", # deps/fpconv
    "MIT", # deps/lua
    any_of: ["CC0-1.0", "BSD-2-Clause"], # deps/hdr_histogram
  ]
  compatibility_version 1
  head "https://github.com/valkey-io/valkey.git", branch: "unstable"

  bottle do
    manifest_sha256 "c7e483926b4fc7f0c545411167a1ed6729b80a22b672691e6051c4c10f8bcb67"
    sha256 cellar: :any, arm64_golden_gate: "d98171540a1e8d2f8d43e6bf6a8555440d05260f44824deeb3c0a6cb00c88e0b"
    sha256 cellar: :any, arm64_tahoe:       "d3caf43049c4ce360dfeae9a844456887252104ff1dd3c259d3a70e65caaea44"
    sha256 cellar: :any, arm64_sequoia:     "0a1f5cd871f8b3d89f6fd9b7f17b6183d197657985d0f357a9f279a7b768d2c0"
    sha256 cellar: :any, arm64_linux:       "c3ed674ed41cf117930428bec876c51e361d68fd4c111edf8681052ad623aea9"
    sha256 cellar: :any, x86_64_linux:      "6f80be41204d140b37085aea196bf24900de854ac256b5eeff4969c46acc68e4"
  end

  depends_on "openssl@4"

  conflicts_with "redis", because: "both install `redis-*` binaries"

  deny_network_access!

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
    %w[run db/valkey log].each { |p| assert_path_exists var/p, "#{var}/#{p} doesn't exist!" }
  end
end
