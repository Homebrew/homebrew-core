class Valkey < Formula
  desc "High-performance data structure server that primarily serves key/value workloads"
  homepage "https://valkey.io"
  url "https://github.com/valkey-io/valkey/archive/refs/tags/9.2.0.tar.gz"
  sha256 "a02cb44db1269b699629e419d4949e6e51e984b1f0e9a984e8ee1e1b3b7cc36f"
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
    sha256 cellar: :any, arm64_golden_gate: "0d7eacdd0f85e5e1275278bb571a1b4e01a641bc21ee24dd1ae204bf0c4468e1"
    sha256 cellar: :any, arm64_tahoe:       "793b66d99df68c0480ed048d36a6eb61dc8c1d36a5c6b995bbd94e702b7ff777"
    sha256 cellar: :any, arm64_sequoia:     "3536e88a1ee6ee7f524645de0e9c57307277e2ef793d311106c1f695b8ecc50e"
    sha256 cellar: :any, arm64_linux:       "a95ea6913aea1cb546f5a47fffb2fb018665f91978f8396eafad42c3903a4d81"
    sha256 cellar: :any, x86_64_linux:      "c47b7eab88d727f9a7c71f5ef0eb81207b3b2bee00ff255928ba1fd8969e0061"
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
    %w[run db/valkey log].each { |p| assert_path_exists var/p, "#{var/p} doesn't exist!" }
  end
end
