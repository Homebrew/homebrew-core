class Redis < Formula
  desc "Persistent key-value database, with built-in net interface"
  homepage "https://redis.io/"
  url "https://download.redis.io/releases/redis-8.6.2.tar.gz"
  sha256 "cea46526594fe05f05b9ff733179eb1263deccf4269059cf081fdef222634c88"
  license all_of: [
    "AGPL-3.0-only",
    "BSD-2-Clause", # deps/jemalloc, deps/linenoise, src/lzf*
    "BSL-1.0", # deps/fpconv
    "MIT", # deps/lua
    any_of: ["CC0-1.0", "BSD-2-Clause"], # deps/hdr_histogram
  ]
  revision 1
  compatibility_version 1
  head "https://github.com/redis/redis.git", branch: "unstable"

  livecheck do
    url "https://download.redis.io/releases/"
    regex(/href=.*?redis[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "dd5fafe58c19aa8f171d06ec58f7233eeefe3178c4f373401e37f476d2b3cd92"
    sha256 cellar: :any,                 arm64_sequoia: "d726a846bff4f74cac045f84d9151f515b7733ff23bf2c28c5ffcbe018c7916b"
    sha256 cellar: :any,                 arm64_sonoma:  "c970f0d89c6664ec9c6929337a7c6a94ad311609d02945052f185ad28c883798"
    sha256 cellar: :any,                 sonoma:        "954968cfbc5e3fcef534b7cd3fe4bf796b209a49e5d2c2ff37e2e9f892f3ebaf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "03295922ca2029d5164cdcd9906b6e2254649e3a6b2b6a4593ec219ef3e2a71b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1eef19f0db6a73cfe21402002d42a96ba43de20f9ad2548ea8a7fdd53b8f5ccb"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "cmake" => :build
  depends_on "coreutils" => :build
  depends_on "libtool" => :build
  depends_on "llvm@18" => :build
  depends_on "python@3.14" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  on_macos do
    depends_on "make" => :build # Needs Make 4.0+
  end

  conflicts_with "valkey", because: "both install `redis-*` binaries"

  resource "redisjson" do
    url "https://github.com/redisjson/redisjson.git",
    revision: "107144fd2c0a6b325108352bf83ed6e6f731a20f"
  end

  resource "redisbloom" do
    url "https://github.com/redisbloom/redisbloom.git",
    revision: "fd8f01c9f13a8d6424481e8c6c9316178f8601b2"
  end

  resource "redistimeseries" do
    url "https://github.com/redistimeseries/redistimeseries.git",
    revision: "05fd355db748676861dc4c17d19c8c1ca74c0154"
  end

  resource "redisearch" do
    url "https://github.com/redisearch/redisearch.git",
    revision: "7782b97574fcdcbee3b724eb26d6d89cc6f6ee51"
  end

  def install
    openssl = Formula["openssl@3"]

    system "make", "install", "PREFIX=#{prefix}", "CC=#{ENV.cc}", "BUILD_TLS=yes"

    resource("redisjson").stage do
      # Add GNU tools to PATH (required by build system)
      ENV.prepend_path "PATH", Formula["coreutils"].opt_libexec/"gnubin"
      # Build the module
      system "gmake", "all"
      lib.install Dir.glob("bin/*-release/rejson.so").first
    end

    resource("redisbloom").stage do
      # Add GNU tools to PATH (required by build system)
      ENV.prepend_path "PATH", Formula["coreutils"].opt_libexec/"gnubin"

      # Set minimum SDK version for macOS
      if OS.mac?
        ENV["OSX_MIN_SDK_VER"] = case MacOS.version
        when :tahoe then "26.0"
        when 15 then "15.0"
        when 14 then "14.0"
        else MacOS.version.to_s
        end
      end

      # Build the module
      system "gmake", "all"
      lib.install Dir.glob("bin/*-release/redisbloom.so").first
    end

    resource("redistimeseries").stage do
      # Add GNU tools to PATH (required by build system)
      ENV.prepend_path "PATH", Formula["coreutils"].opt_libexec/"gnubin"

      # Set compiler flags for OpenSSL
      ENV.append "CFLAGS", "-I#{openssl.opt_include}"
      ENV.append "CXXFLAGS", "-I#{openssl.opt_include}"
      ENV.append "CPPFLAGS", "-I#{openssl.opt_include}"
      ENV.append "LDFLAGS", "-L#{openssl.opt_lib}"
      # Build the module
      system "gmake", "build", "openssl_prefix=#{openssl.opt_prefix}", "OPENSSL_PREFIX=#{openssl.opt_prefix}"
      lib.install Dir.glob("bin/*-release/redistimeseries.so").first
    end

    resource("redisearch").stage do
      # Add GNU tools to PATH (required by build system)
      ENV.prepend_path "PATH", Formula["coreutils"].opt_libexec/"gnubin"
      # RediSearch has been verified to support runtime CPU detection for SIMD optimizations
      ENV.runtime_cpu_detection
      # Build the module
      system "gmake", "build", "OPENSSL_ROOT_DIR=#{openssl.opt_prefix}", "IGNORE_MISSING_DEPS=1"
      lib.install Dir.glob("bin/*-release/search-community/redisearch.so").first
    end

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

  def post_install
    # Set execute permissions on module files
    %w[redisbloom.so rejson.so redisearch.so redistimeseries.so].each do |file|
      chmod 0755, lib/file
    end

    # Add loadmodule directives to redis.conf
    redis_conf = Pathname.new(HOMEBREW_PREFIX)/"etc/redis.conf"

    if redis_conf.exist?
      conf_content = redis_conf.read

      # Add loadmodule directives for each Redis module
      %w[redisbloom.so rejson.so redisearch.so redistimeseries.so].each do |file|
        module_path = opt_lib/file
        loadmodule_line = "loadmodule #{module_path}"

        next if conf_content.include?(loadmodule_line)

        ohai "Adding #{file} module to redis.conf"
        File.open(redis_conf, "a") do |f|
          f.write "\n# #{file} module\n"
          f.write "#{loadmodule_line}\n"
        end
        conf_content = redis_conf.read
      end
    else
      opoo "redis.conf not found at #{redis_conf}"
    end
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

    # Test that all modules can be loaded
    %w[redisbloom.so rejson.so redisearch.so redistimeseries.so].each do |file|
      module_path = lib/file
      assert_path_exists module_path, "#{file} module not found at #{module_path}"

      # Test that the module loads successfully
      output = shell_output("#{bin}/redis-server --loadmodule #{module_path} --test-memory 2 2>&1", 1)
      assert_match(/Module.*loaded from/, output)
    end
  end
end
