class Redisearch < Formula
  desc "Json data structure for Redis"
  homepage "https://redis.io/docs/latest/operate/oss_and_stack/stack-with-enterprise/search/"
  url "https://github.com/redisearch/redisearch.git",
      tag:      "v8.4.2",
      revision: "9e2b676313f417209c3464fe21ae166ef931b770"
  license "AGPL-3.0-or-later"
  head "https://github.com/redisearch/redisearch.git", branch: "master"

  depends_on "cmake" => :build
  depends_on "llvm@18" => :build
  depends_on "rust" => :build

  depends_on "openssl@3"
  depends_on "redis"

  def install
    llvm = Formula["llvm@18"]
    openssl = Formula["openssl@3"]

    ENV.prepend_path "PATH", llvm.opt_bin

    system "./build.sh", "COORD=oss", "OPENSSL_ROOT_DIR=#{openssl.opt_prefix}", "IGNORE_MISSING_DEPS=1"

    module_files = Dir.glob("bin/*-release/search-community/redisearch.so")
    lib.install module_files.first

    (etc/"redisearch.conf").write <<~EOS
      loadmodule #{opt_lib}/redisearch.so
    EOS
  end

  def post_install
    # Set execute permissions on the module
    source_module = lib/"redisearch.so"
    chmod 0755, source_module

    # Add include directive to redis.conf if not already present
    # After uninstalling the include statement will be ignored and no error will be emitted
    redis_conf = Pathname.new(HOMEBREW_PREFIX)/"etc/redis.conf"

    if redis_conf.exist?
      conf_content = redis_conf.read
      include_line = "include #{opt_prefix}/conf/*.conf"

      unless conf_content.include?(include_line)
        ohai "Adding RediSearch module include to redis.conf"
        File.open(redis_conf, "a") do |f|
          f.write "\n# RediSearch module\n"
          f.write "#{include_line}\n"
        end
      end
    else
      opoo "redis.conf not found at #{redis_conf}"
      opoo "Please ensure Redis is installed before installing RediSearch"
    end
  end

  def caveats
    <<~EOS
      RediSearch module has been installed to:
        #{opt_lib}/redisearch.so

      To use this module:

      If Redis is managed by brew services:
        brew services restart redis

      If running Redis manually with the config file:
        redis-server #{HOMEBREW_PREFIX}/etc/redis.conf

      If running Redis manually without the config file:
        redis-server --loadmodule #{opt_lib}/redisearch.so
    EOS
  end

  test do
    # Test that the module loads successfully
    module_path = opt_lib/"redisearch.so"
    output = shell_output("redis-server --loadmodule #{module_path} --test-memory 2 2>&1", 1)
    # Redis will exit with error when using --test-memory with modules, but module should load
    assert_match "Module 'search' loaded", output
  end
end
