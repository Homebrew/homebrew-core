class Valkey < Formula
  desc "High-performance data structure server that primarily serves key/value workloads"
  homepage "https://valkey.io"
  url "https://github.com/valkey-io/valkey/archive/refs/tags/7.2.6.tar.gz"
  sha256 "5272f244deecd5655d805aabc71c84a7c7699bc4fa009dd7fc550806a042d512"
  license all_of: [
    "BSD-3-Clause",
    "BSD-2-Clause", # deps/jemalloc, deps/linenoise, src/lzf*
    "BSL-1.0", # deps/fpconv
    "MIT", # deps/lua
    any_of: ["CC0-1.0", "BSD-2-Clause"], # deps/hdr_histogram
  ]
  head "https://github.com/valkey-io/valkey.git", branch: "unstable"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "d3cd139668e121b5caa306ce301fda2614ca1b46941fe25db5a0a9b80a6ad8dd"
    sha256 cellar: :any,                 arm64_ventura:  "de9f479d5978b0bbf635299d225c3068a5e7f5aac8a410fbdf173a9cd78b3185"
    sha256 cellar: :any,                 arm64_monterey: "85a845363f2832856e4cbf131844254283b4c2c56f1a383a19bebf68be60a5d0"
    sha256 cellar: :any,                 sonoma:         "b9b53942e9c10157cd99511dde13f531dced1ab8a0f9cb6951af0b6f30f03f68"
    sha256 cellar: :any,                 ventura:        "20de31a33ccff361c090da4991463f7f7566014d00ce1a80773a6c1d9f026e23"
    sha256 cellar: :any,                 monterey:       "6c1438f58b815998b049b1fbd21d15d22dc4691b5844954a44b453d1ef38466c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d87aa424286c347de00f181b805ad13714b9747987f649f2864239d29da53904"
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
