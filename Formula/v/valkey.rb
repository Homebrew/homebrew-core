class Valkey < Formula
  desc "High-performance data structure server that primarily serves key/value workloads"
  homepage "https://valkey.io"
  url "https://github.com/valkey-io/valkey/archive/refs/tags/9.0.0.tar.gz"
  sha256 "088f47e167eb640ea31af48c81c5d62ee56321f25a4b05d4e54a0ef34232724b"
  license all_of: [
    "BSD-3-Clause",
    "BSD-2-Clause", # deps/jemalloc, deps/linenoise, src/lzf*
    "BSL-1.0", # deps/fpconv
    "MIT", # deps/lua
    any_of: ["CC0-1.0", "BSD-2-Clause"], # deps/hdr_histogram
  ]
  head "https://github.com/valkey-io/valkey.git", branch: "unstable"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "ee3308904a57c7075476c4a2a24acb60cc06902094070bc813c99a0a751cdc30"
    sha256 cellar: :any,                 arm64_sequoia: "e7f33f1532584d45173e4d5abe6f47a0e028ee0d4891b568b41ecaf27615c54f"
    sha256 cellar: :any,                 arm64_sonoma:  "f4fa02ca5ef0ed8394333bccc33bc3cf6bb4d78b1ddc97f91599684243273158"
    sha256 cellar: :any,                 sonoma:        "ca251acd0cecda0ce5ecae2ad07c7404056d83641650c2b5d1ed065e4b3d0271"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1f92b04c0ac2a7483847701f0221f94141dcaafd753492c09a8d20b8c0da221b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ded3d34faf48e176c5828c32371e96204e170e249fc5b03c77bfe64bfb0d8be3"
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
