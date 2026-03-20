class Redis < Formula
  desc "Persistent key-value database, with built-in net interface"
  homepage "https://redis.io/"
  url "https://download.redis.io/releases/redis-8.6.1.tar.gz"
  sha256 "6873fc933eeb7018aa329e868beac7228695f50c0d46f236a4ff1a6d7f7bb5b6"
  license all_of: [
    "AGPL-3.0-only",
    "BSD-2-Clause", # deps/jemalloc, deps/linenoise, src/lzf*
    "BSL-1.0", # deps/fpconv
    "MIT", # deps/lua
    any_of: ["CC0-1.0", "BSD-2-Clause"], # deps/hdr_histogram
  ]
  head "https://github.com/redis/redis.git", branch: "unstable"

  livecheck do
    url "https://download.redis.io/releases/"
    regex(/href=.*?redis[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "ca41e968b63f67c895ea643e8779fec5d8415b5147a03c246af8deb80ed684f2"
    sha256 cellar: :any,                 arm64_sequoia: "044fa147f99ec185be38a2f2d581c70781f9c476986864ac95dc4b4e6329ffdf"
    sha256 cellar: :any,                 arm64_sonoma:  "8af62bc0aeeb898b94eb3838006a759b828219d8626505ed2f8f8e5b0cd0a18d"
    sha256 cellar: :any,                 sonoma:        "a8611fb5838323d0e18ea12ad164edf73731952d6221fee11eb4404815b62294"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bd42445613067005996dcb21e0af8c987c835e04e7d1fd8591287cfb15974a5a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b11b567ada7461aa9638502533a446a8dc89021cca290214389d4693900fd5ed"
  end

  depends_on "openssl@3"

  conflicts_with "valkey", because: "both install `redis-*` binaries"

  def install
    system "make", "install", "PREFIX=#{prefix}", "CC=#{ENV.cc}", "BUILD_TLS=yes"

    %w[run db/redis log].each { |p| (var/p).mkpath }

    # Fix up default conf file to match our paths
    inreplace "redis.conf" do |s|
      s.gsub! "/var/run/redis_6379.pid", var/"run/redis.pid"
      s.gsub! "dir ./", "dir #{var}/db/redis/"
      s.sub!(/^bind .*$/, "bind 127.0.0.1 ::1")
    end

    etc.install "redis.conf"
    etc.install "sentinel.conf" => "redis-sentinel.conf"
  end

  service do
    run [opt_bin/"redis-server", etc/"redis.conf"]
    keep_alive true
    error_log_path var/"log/redis.log"
    log_path var/"log/redis.log"
    working_dir var
  end

  test do
    system bin/"redis-server", "--test-memory", "2"
    %w[run db/redis log].each { |p| assert_path_exists var/p, "#{var/p} doesn't exist!" }
  end
end
