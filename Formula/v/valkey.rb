class Valkey < Formula
  desc "High-performance data structure server that primarily serves key/value workloads"
  homepage "https://valkey.io"
  url "https://github.com/valkey-io/valkey/archive/refs/tags/8.0.1.tar.gz"
  sha256 "1e1d6dfbed2f932a87afbc7402be050a73974a9b19a9116897e537a6638e5e1d"
  license all_of: [
    "BSD-3-Clause",
    "BSD-2-Clause", # deps/jemalloc, deps/linenoise, src/lzf*
    "BSL-1.0", # deps/fpconv
    "MIT", # deps/lua
    any_of: ["CC0-1.0", "BSD-2-Clause"], # deps/hdr_histogram
  ]
  head "https://github.com/valkey-io/valkey.git", branch: "unstable"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "a305a3fd53b53997a9891b04ec5dfe833bc8e6f8e279003f3bcb9fff1859cb82"
    sha256 cellar: :any,                 arm64_sonoma:  "1ba0db271faa7a7f0253ac5082397e34735cfe94dd11d1c7441bedb5b7c52491"
    sha256 cellar: :any,                 arm64_ventura: "663f7e18a04c44a70a236752c0cdcd49c4b7cc28695bca94d76d2702f5172e6a"
    sha256 cellar: :any,                 sonoma:        "340130c0cade2f030a79d7a035ad213d5ebc4091d2a2a25f96cc97667b641beb"
    sha256 cellar: :any,                 ventura:       "f99a2b6a8ec68c169c4221e3eb7a3d89ddaaa3d2a2d0190302d5310cdd899ad4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5a03be3c2728970bb5ae209043a9d7c20e05ce144d6c2d725d166d169d268d42"
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
    %w[run db/valkey log].each { |p| assert_predicate var/p, :exist?, "#{var/p} doesn't exist!" }
  end
end
