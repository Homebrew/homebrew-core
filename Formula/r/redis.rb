class Redis < Formula
  desc "Persistent key-value database, with built-in net interface"
  homepage "https://redis.io/"
  url "https://download.redis.io/releases/redis-8.10.0.tar.gz"
  sha256 "f1baa4b28befd417aa6577ebeedde9e9fc7814cfcc299b2a6d2fd99ef7420a6c"
  license all_of: [
    "AGPL-3.0-only",
    "Apache-2.0", # modules: ScalableVectorSearch, cpu_features
    "BSD-2-Clause", # deps/jemalloc, deps/linenoise, src/lzf*
    "BSD-3-Clause", # modules: libevent, hiredis, readies
    "BSL-1.0", # deps/fpconv, modules: boost, eve, dragonbox, fast_double_parser
    "MIT", # deps/lua, modules: fmt, spdlog, robin-map, tomlplusplus, fast_float, t-digest-c
    any_of: ["CC0-1.0", "BSD-2-Clause"], # deps/hdr_histogram
  ]
  compatibility_version 1
  head "https://github.com/redis/redis.git", branch: "unstable"

  livecheck do
    url "https://download.redis.io/releases/"
    regex(/href=.*?redis[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "f2ef2c9af97cfad02c132618e535628a1396561f0304d25e4e893534f9376c8d"
    sha256 cellar: :any, arm64_sequoia: "22de562c378e6108f6a425a307dd2d58d36fa92e5a0ae5a56e8b076e73090f43"
    sha256 cellar: :any, arm64_sonoma:  "49d2971ce2b3c61e71d5b9aef112c5c813ee06082fa49bcb5a3ed1cec5132340"
    sha256 cellar: :any, sonoma:        "86db1445cf7e6027e2fb315508376146d122509b20252f4f4351b48653d9a1bd"
    sha256 cellar: :any, arm64_linux:   "23e63ef02fd84a6bd8a7e3ef263e96d7977a562efc7c8985efbe0c8295c72731"
    sha256 cellar: :any, x86_64_linux:  "89491b60e2d6bbc3e97af40a962776d1b2aab58861aaa402a158e5f96669516e"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "cmake" => :build
  depends_on "libtool" => :build
  depends_on "python@3.14" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  uses_from_macos "llvm" => :build # for bindgen

  on_macos do
    depends_on "make" => :build # RediSearch needs Make 4.0+
  end

  conflicts_with "valkey", because: "both install `redis-*` binaries"

  def redis_modules = %w[redisbloom.so redisearch.so redistimeseries.so rejson.so]

  def install
    # RediSearch sets `CMAKE_CXX_STANDARD` inside a function without `PARENT_SCOPE`,
    # so no `-std` reaches the compile line and the compiler default is used instead.
    ENV.append "CXXFLAGS", "-std=gnu++20"
    # VectorSimilarity selects its SIMD kernels at runtime via cpu_features.
    ENV.runtime_cpu_detection
    ENV.prepend_path "PATH", Formula["make"].libexec/"gnubin" if OS.mac?

    system "make", "deploy", "PREFIX=#{prefix}", "CC=#{ENV.cc}", "CXX=#{ENV.cxx}",
           "BUILD_TLS=yes", "REDISEARCH_GENERATE_HEADERS=0", "IGNORE_MISSING_DEPS=1", "LTO=0"

    %w[run db/redis log].each { |p| (var/p).mkpath }

    # Fix up default conf file to match our paths
    inreplace "redis.conf" do |s|
      s.gsub! "/var/run/redis_6379.pid", var/"run/redis.pid"
      s.gsub! "dir ./", "dir #{var}/db/redis/"
      s.sub!(/^bind .*$/, "bind 127.0.0.1 ::1")
      s.gsub! "#{lib}/redis/modules", "#{opt_lib}/redis/modules"
    end

    etc.install "redis.conf"
    etc.install "sentinel.conf" => "redis-sentinel.conf"
  end

  post_install_steps do
    set_permissions "redis/modules", "a+x", base: :lib
  end

  service do
    run [opt_bin/"redis-server", etc/"redis.conf"]
    keep_alive true
    error_log_path var/"log/redis.log"
    log_path var/"log/redis.log"
    working_dir var
  end

  test do
    %w[run db/redis log].each { |p| assert_path_exists var/p, "#{var/p} doesn't exist!" }

    # Test that all modules can be loaded
    redis_modules.each do |file|
      output = shell_output("#{bin}/redis-server --loadmodule #{lib/"redis/modules"/file} --test-memory 2 2>&1", 1)
      assert_match(/Module.*loaded from/, output)
    end
  end
end
