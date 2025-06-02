class Valkey < Formula
  desc "High-performance data structure server that primarily serves key/value workloads"
  homepage "https://valkey.io"
  url "https://github.com/valkey-io/valkey/archive/refs/tags/8.1.1.tar.gz"
  sha256 "3355fbd5458d853ab201d2c046ffca9f078000587ccbe9a6c585110f146ad2c5"
  license all_of: [
    "BSD-3-Clause",
    "BSD-2-Clause", # deps/jemalloc, deps/linenoise, src/lzf*
    "BSL-1.0", # deps/fpconv
    "MIT", # deps/lua
    any_of: ["CC0-1.0", "BSD-2-Clause"], # deps/hdr_histogram
  ]
  head "https://github.com/valkey-io/valkey.git", branch: "unstable"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "22efc3dadf1f4b35e1b3daec995dd2a5e36e1e3a3868c7dfc081fada6606db35"
    sha256 cellar: :any,                 arm64_sonoma:  "0bc6af893af7e5e9a44353284f613259013cf6920dae414e5c4a1ebf555f4846"
    sha256 cellar: :any,                 arm64_ventura: "e5fbb187d387982c398a4df98404ad9fe667051fcde89f7b17fa199e8c319abf"
    sha256 cellar: :any,                 sonoma:        "f529f685e9cf947746a869f530f15c708baa85f34df666bd88a192c9d44055e2"
    sha256 cellar: :any,                 ventura:       "14cd2ea4515f6280bfc396a7e56fa63ce3d5dc94a99278081303edb277391a1a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5b1687378a42d5b0ebecc79b840278cb94f33fb4b4a655f0bbe71c600b097c1a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6dffc41005fd89ac2fb57190c2e9e40617dcd075316526321e1c05ebd364017c"
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
