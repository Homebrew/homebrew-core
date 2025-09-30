class Valkey < Formula
  desc "High-performance data structure server that primarily serves key/value workloads"
  homepage "https://valkey.io"
  url "https://github.com/valkey-io/valkey/archive/refs/tags/8.1.3.tar.gz"
  sha256 "8f862b3b0a72fd40587793964539589f6f83d01361ca1598b370cfaa301e0ec0"
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
    sha256 cellar: :any,                 arm64_tahoe:   "229a7e5f052d0a07b5f3ee473412b6047c3ba5e07c4231c9be1413de16059a05"
    sha256 cellar: :any,                 arm64_sequoia: "520366e6260725ba358ee78eaac9e27a3172f6e0d788f0b6c02b5f880b297789"
    sha256 cellar: :any,                 arm64_sonoma:  "026c24be9de7fe02ead9d36a2a8d9ec57fecd7299330c215d599625d59e6492c"
    sha256 cellar: :any,                 arm64_ventura: "5310fc2432984d2357e8ee52bd7afa45a4ed64c0bf37c1aa10a94c04b4f01ebe"
    sha256 cellar: :any,                 sonoma:        "cdfe24b762086915ed409b60c3b23e3b901897db7ea0b6dfe7df4ee9802e956e"
    sha256 cellar: :any,                 ventura:       "841071f0b670a3502cbab144532e2aa2f2b8aa04372bc269ba15f92823cfae81"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "29574d4de17abef60d386b9fdae3fbe14e019cadfa715a42a78cd892c52397be"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ac03ef7e2d2d459516bc39e082fe1327dd339f2c793067682ce78d7a204d8f53"
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
