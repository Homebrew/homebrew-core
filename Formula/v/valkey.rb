class Valkey < Formula
  desc "High-performance data structure server that primarily serves key/value workloads"
  homepage "https://valkey.io"
  url "https://github.com/valkey-io/valkey/archive/refs/tags/9.1.1.tar.gz"
  sha256 "7d7232acd1b8a49b4e05d07a00b3ca8c801ae06ab633ca6a3423bc5f385ab7ee"
  license all_of: [
    "BSD-3-Clause",
    "BSD-2-Clause", # deps/jemalloc, deps/linenoise, src/lzf*
    "BSL-1.0", # deps/fpconv
    "MIT", # deps/lua
    any_of: ["CC0-1.0", "BSD-2-Clause"], # deps/hdr_histogram
  ]
  head "https://github.com/valkey-io/valkey.git", branch: "unstable"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "8bef52c4e766fd508af5006eab8df8ae828333006abbd64ec4dbcd05aeb7e35f"
    sha256 cellar: :any, arm64_sequoia: "9daebe4f106b9f2d2e31c91a971c7622a17f3691a1a3002cb0af3aed5b0bcf1f"
    sha256 cellar: :any, arm64_sonoma:  "e095b15ff5e6ac9825a5fa2b4f141349d88e95745d5e228829d2fa626f01d6cd"
    sha256 cellar: :any, sonoma:        "c362cd074ce219adcf25b58395bc15bbb49c1e43037aa6f22a8ae116716920b7"
    sha256 cellar: :any, arm64_linux:   "70b43be43258df6d7bd5e6924d625644c586a0697623010249a3da520a5d6b2d"
    sha256 cellar: :any, x86_64_linux:  "f6afc11b1f9e6833e3462a1513dbbb292f7faf8e668c6e5639154497c7830a4b"
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
