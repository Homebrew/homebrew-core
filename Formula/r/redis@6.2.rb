class RedisAT62 < Formula
  desc "Persistent key-value database, with built-in net interface"
  homepage "https://redis.io/"
  url "https://download.redis.io/releases/redis-6.2.18.tar.gz"
  sha256 "470c75bac73d7390be4dd66479c6f29e86371c5d380ce0c7efb4ba2bbda3612d"
  license all_of: [
    "BSD-3-Clause",
    "BSD-2-Clause", # deps/jemalloc, deps/linenoise, src/lzf*
    "BSL-1.0", # deps/fpconv
    "MIT", # deps/lua
    any_of: ["CC0-1.0", "BSD-2-Clause"], # deps/hdr_histogram
  ]

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "67957e45281bea703053e491f7529026d8492bd81e1bc241e6005b526764c064"
    sha256 cellar: :any,                 arm64_sequoia: "bd4e8b149de304f96ca737de9dbbfa4a3055dd93df5a0bf42d25dec056bc81d3"
    sha256 cellar: :any,                 arm64_sonoma:  "097a41d0f9e5c0a68981de1230d7d7d9cda8454aed0ac9ff038e8f48e2a5214e"
    sha256 cellar: :any,                 arm64_ventura: "d7b8f49e152b41dddd01e44015424e734611fe425d701addfa7e11104382a1e5"
    sha256 cellar: :any,                 sonoma:        "c6ce47934e8471c0cdc128cc75006801bf33d06c81671c4d1c0a4bf5d75b83dc"
    sha256 cellar: :any,                 ventura:       "8dcf0d2129f3c31221f1e23f794c0f5fc0947916487ae7618e84855125353200"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d1ed6c23281c8f3761df36bd4612aa05aeeee9f8850ad243cf85ca163acf6b5f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9527caad1fa914cd32ccd99b917c5b98860613dbc37ff7ea36c8d10d0371b769"
  end

  keg_only :versioned_formula

  # See EOL, https://redis.io/docs/latest/operate/rs/installing-upgrading/product-lifecycle/
  deprecate! date: "2025-04-24", because: :unsupported

  depends_on "openssl@3"

  def install
    system "make", "install", "PREFIX=#{prefix}", "CC=#{ENV.cc}", "BUILD_TLS=yes"

    %w[run db/redis log].each { |p| (var/p).mkpath }

    # Fix up default conf file to match our paths
    inreplace "redis.conf" do |s|
      s.gsub! "/var/run/redis.pid", var/"run/redis.pid"
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
