class Valkey < Formula
  desc "High-performance data structure server that primarily serves key/value workloads"
  homepage "https://valkey.io"
  url "https://github.com/valkey-io/valkey/archive/refs/tags/9.1.4.tar.gz"
  sha256 "fe3d623600a1c046b4668feec097c507b4ae52f20c1fc7f1ebd384c07a165e77"
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
    sha256 cellar: :any, arm64_golden_gate: "c778919fb7166a578525b9855f9e7c83b5dcde4560410d0050a4f2b46abcf4e9"
    sha256 cellar: :any, arm64_tahoe:       "2f37ec3eddecbb3e8736edbc7b50e52c2aa1c4ad5d9e8d76cca3017880073d58"
    sha256 cellar: :any, arm64_sequoia:     "073d1b003e9b4008c3bb17f7fd98fbec807cd79858ac1f8e6d72ffbe5c1a6067"
    sha256 cellar: :any, arm64_linux:       "1646f3934be91b1d3e552bfb4e66e3e14bb7bd6870b0b9a189b85e021f9875e6"
    sha256 cellar: :any, x86_64_linux:      "cd05678f4a1623f9ed6e78a2c595eef01284fc56363181caa97da17fa4e1518f"
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
