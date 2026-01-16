class Valkey < Formula
  desc "High-performance data structure server that primarily serves key/value workloads"
  homepage "https://valkey.io"
  url "https://github.com/valkey-io/valkey/archive/refs/tags/9.0.1.tar.gz"
  sha256 "9cfbc5f32a2a6058ee0f8c532b9c4d24167cc49d719f091dd75f1bb8353a1fc5"
  license all_of: [
    "BSD-3-Clause",
    "BSD-2-Clause", # deps/jemalloc, deps/linenoise, src/lzf*
    "BSL-1.0", # deps/fpconv
    "MIT", # deps/lua
    any_of: ["CC0-1.0", "BSD-2-Clause"], # deps/hdr_histogram
  ]
  head "https://github.com/valkey-io/valkey.git", branch: "unstable"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "54f90d4322ca6d169c361df71504abd5081417059fbaca2a415f783e50b47ab5"
    sha256 cellar: :any,                 arm64_sequoia: "f3ed5832c34d998d2e899ef61e5da1619286b37f6f327d43e4ef42d0276f65b7"
    sha256 cellar: :any,                 arm64_sonoma:  "ac98b63602dcc892f1913806005b27b7c042c5fa37f5819abfd68fefaa6e80bf"
    sha256 cellar: :any,                 sonoma:        "5570a8590a990c1c1177814315718d8bbe2f09b5c3711ce3d737c20e63fc7ef0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cdd1c6cdb27e1423fb3e3caf93b49391a0736ec68d64859e0110035597353ada"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1fbadf8df708530dcf823bbccca58ceb7ddb93792a3c898136515ce4fc701ae9"
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
