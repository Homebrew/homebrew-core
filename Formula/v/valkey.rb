class Valkey < Formula
  desc "High-performance data structure server that primarily serves key/value workloads"
  homepage "https://valkey.io"
  url "https://github.com/valkey-io/valkey/archive/refs/tags/9.0.2.tar.gz"
  sha256 "0ebaa583659ab784ce19170627032cfab7793a5570b7262775f9dbf77c103ec7"
  license all_of: [
    "BSD-3-Clause",
    "BSD-2-Clause", # deps/jemalloc, deps/linenoise, src/lzf*
    "BSL-1.0", # deps/fpconv
    "MIT", # deps/lua
    any_of: ["CC0-1.0", "BSD-2-Clause"], # deps/hdr_histogram
  ]
  head "https://github.com/valkey-io/valkey.git", branch: "unstable"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "035b175b2c6f1d151bd3b34e82e64de7a8eed0fbbd7108b20f8633b8a6826aca"
    sha256 cellar: :any,                 arm64_sequoia: "ba944dc1057098e602d50860ec04f7aa3c13a5895623bae9e177abbdae1fad79"
    sha256 cellar: :any,                 arm64_sonoma:  "e99d08bda23f2a7a540265507c22dbc58bbb0683114ee586133f8ecc5e53638f"
    sha256 cellar: :any,                 sonoma:        "180c21581c0590f743f6a504bea268db48bf03cbc413ef893e8c28844deecf92"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "db8a717ffaf5a7ccf88ae09c817a5cfbde39d89d808f8efa30b6224c279132ce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "14dad301e80e63b062140810c7b147ada47408083d7b43e09daa67996d08d8bb"
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
