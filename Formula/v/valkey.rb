class Valkey < Formula
  desc "High-performance data structure server that primarily serves key/value workloads"
  homepage "https://valkey.io"
  url "https://github.com/valkey-io/valkey/archive/refs/tags/9.0.3.tar.gz"
  sha256 "e220f4b0143292ee6ea6d705aa40d45a0c8a77759b3e94c201cb5c25dbdca42f"
  license all_of: [
    "BSD-3-Clause",
    "BSD-2-Clause", # deps/jemalloc, deps/linenoise, src/lzf*
    "BSL-1.0", # deps/fpconv
    "MIT", # deps/lua
    any_of: ["CC0-1.0", "BSD-2-Clause"], # deps/hdr_histogram
  ]
  head "https://github.com/valkey-io/valkey.git", branch: "unstable"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "27541b3465274ab0801fa28b76f4412004071b7940edaa09d7daeee442ba9d46"
    sha256 cellar: :any,                 arm64_sequoia: "1e746c5dc69a16aab8c18e079712d0bf66085298dbb8d649d229073fcffbd11e"
    sha256 cellar: :any,                 arm64_sonoma:  "04eb1cce12e503486bccb3f60afe869c7409ce91a8fe38fa9311cf47523cbd32"
    sha256 cellar: :any,                 sonoma:        "1ce8587dfc9292cfaa781e501c7ace8f2b893d018c1eb1607d5b92c311f0601c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2063106c5a6227585cfb66e55e1aa8837370131b4cf3d999f18c7613c057852c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3a12be9914ab13cb2ef2d657a42da13580a05a81c60f16bffb03e5bccaf46cf0"
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
