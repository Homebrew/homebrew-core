class Valkey < Formula
  desc "High-performance data structure server that primarily serves key/value workloads"
  homepage "https://valkey.io"
  url "https://github.com/valkey-io/valkey/archive/refs/tags/9.1.3.tar.gz"
  sha256 "184e34ed2d9b51879b682b5b15205e2b9d677c60280e3cb453be8f520d04e293"
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
    sha256 cellar: :any, arm64_golden_gate: "bf1d6cf0f83558024ff7c2e8bd47b0ad9bab6b833e30d2d6591c356386127f97"
    sha256 cellar: :any, arm64_tahoe:       "7750c1dda4336e76ee0392f8d70a25574456cb63ac9edd69cef4e659601c4713"
    sha256 cellar: :any, arm64_sequoia:     "06a7170e3c0c86884b25578bcb083b68bc47715c5e5ee4ce31e8b95311e22027"
    sha256 cellar: :any, arm64_linux:       "8fb34f24c8e09d0060dbb860f5fc826ccb8fd20b2335a6a43d640ed82fae4bf1"
    sha256 cellar: :any, x86_64_linux:      "e509dc1946dd3c33bd0bdc6c50788fffb4821fcfc510f46b838d0970b79b095b"
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
