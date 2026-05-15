class Valkey < Formula
  desc "High-performance data structure server that primarily serves key/value workloads"
  homepage "https://valkey.io"
  url "https://github.com/valkey-io/valkey/archive/refs/tags/9.0.4.tar.gz"
  sha256 "8d65e12cc9edb14d117b56fd33300e7b8cde2c087356de3f055d44689667670b"
  license all_of: [
    "BSD-3-Clause",
    "BSD-2-Clause", # deps/jemalloc, deps/linenoise, src/lzf*
    "BSL-1.0", # deps/fpconv
    "MIT", # deps/lua
    any_of: ["CC0-1.0", "BSD-2-Clause"], # deps/hdr_histogram
  ]
  head "https://github.com/valkey-io/valkey.git", branch: "unstable"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "a8a1cf4f05c77725fb6c705fc1c31737a5570d49965825806872447bc646bfc4"
    sha256 cellar: :any,                 arm64_sequoia: "e6cb3dc92e054fcd11fb0cde9915bc776430456487eeb30a090aeeceab8bf8bd"
    sha256 cellar: :any,                 arm64_sonoma:  "a8126276a868a854e911dfcde53b081778f39d8f3a069f7b0f1567627d6000df"
    sha256 cellar: :any,                 sonoma:        "455c72e95371c06a05823aa0fa66eaebee1dece6b4bbda7a0665d9bedd21450d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4369845f628cb89cd06c1ff4890915c72fcab1417628178c8b50c8411223adb8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e10b765375cfa518fed0496e1ac3a19b2645f5300983695d314f88d217a9f2a1"
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
