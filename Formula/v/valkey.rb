class Valkey < Formula
  desc "High-performance data structure server that primarily serves key/value workloads"
  homepage "https://valkey.io"
  url "https://github.com/valkey-io/valkey/archive/refs/tags/8.1.4.tar.gz"
  sha256 "32350b017fee5e1a85f7e2d8580d581a0825ceae5cb3395075012c0970694dee"
  license all_of: [
    "BSD-3-Clause",
    "BSD-2-Clause", # deps/jemalloc, deps/linenoise, src/lzf*
    "BSL-1.0", # deps/fpconv
    "MIT", # deps/lua
    any_of: ["CC0-1.0", "BSD-2-Clause"], # deps/hdr_histogram
  ]
  head "https://github.com/valkey-io/valkey.git", branch: "unstable"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "bdca078679bd195db2607714510eafde9368904f4d67b7c16fb0394dc08e1a7a"
    sha256 cellar: :any,                 arm64_sequoia: "bd794b61b5f1f62f03e4e274ad642bbd7606b22d3b6e35bf560f66675150f5a9"
    sha256 cellar: :any,                 arm64_sonoma:  "f1808fcc239f01620c974efcc72fc57d0c8bf481823906302588f59354b6a761"
    sha256 cellar: :any,                 sonoma:        "df9a881984fa6e16e0a7e9be835e61507c2e265e101b01c80e24b7cc228f20bc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9d324db062ea24e76d9b7fcccee8e69a153439ea7bb705cc227bce878b61cdfa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ffcbca4e67409e16edf8bc51c7e329dff241539013964a2f0a4828e3029fff95"
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
