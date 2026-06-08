class Valkey < Formula
  desc "High-performance data structure server that primarily serves key/value workloads"
  homepage "https://valkey.io"
  url "https://github.com/valkey-io/valkey/archive/refs/tags/9.1.0.tar.gz"
  sha256 "7789fe1df257774457bafb4c1d56c9f7020c3879a7f5b4234af9030b2bd82dfd"
  license all_of: [
    "BSD-3-Clause",
    "BSD-2-Clause", # deps/jemalloc, deps/linenoise, src/lzf*
    "BSL-1.0", # deps/fpconv
    "MIT", # deps/lua
    any_of: ["CC0-1.0", "BSD-2-Clause"], # deps/hdr_histogram
  ]
  head "https://github.com/valkey-io/valkey.git", branch: "unstable"

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_tahoe:   "065a69890faf06afd40894712127dd111a2246d07beb719a0ae135b7903ce804"
    sha256 cellar: :any, arm64_sequoia: "56d7f776d0d9bc82265d415234018cc20a90f19e65b76d58c5059355a2205b6f"
    sha256 cellar: :any, arm64_sonoma:  "a58f51ca54dcb90b5ed0469c47cf05a366357b6f1c5eab3b50f51a8721b9d520"
    sha256 cellar: :any, sonoma:        "1da6e1528f6cb9aa0787951cd5a895f6a6b241461663f1ce679b6f08ba39a435"
    sha256 cellar: :any, arm64_linux:   "769b0942ae3f446c28e6d970e580728c96316c5bfd4f32e8bda698d9bb2e6850"
    sha256 cellar: :any, x86_64_linux:  "78e448416a123f80e3f583f2b3d2580452715f922c3996cc283317bbe52bacf9"
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
