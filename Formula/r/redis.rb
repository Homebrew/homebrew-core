class Redis < Formula
  desc "Persistent key-value database, with built-in net interface"
  homepage "https://redis.io/"
  # NOTE: Do not bump to v7.4+ as license changed to RSALv2+SSPLv1
  # https://github.com/redis/redis/pull/13157
  url "https://download.redis.io/releases/redis-7.2.4.tar.gz"
  sha256 "8d104c26a154b29fd67d6568b4f375212212ad41e0c2caa3d66480e78dbd3b59"
  license "BSD-3-Clause"
  head "https://github.com/redis/redis.git", branch: "unstable"

  livecheck do
    url "https://download.redis.io/releases/"
    regex(/href=.*?redis[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "7840031cf7bb94c62d6e42b6e730e8447c31ae37e3564a43a772fb8e6e0e51cf"
    sha256 cellar: :any,                 arm64_ventura:  "975f8c13a24d1b0f4a8e0f3c9ea2338d209ec9bcfcebd3130d0a72c3e4809c58"
    sha256 cellar: :any,                 arm64_monterey: "ac32435ac27d8a061ee32ba88cf842ee3dff64a85803aa4d6a65d841e32ccbbd"
    sha256 cellar: :any,                 sonoma:         "09767dffd13dd62aed6bb904f35946c3b9dae2db58cc884dc179d6e12b573673"
    sha256 cellar: :any,                 ventura:        "3ce1ca917e08acf3cad5023e0d7184505be327f797f18eb692711325d8c540c9"
    sha256 cellar: :any,                 monterey:       "357f32b7bbe42ae1323d693bebd756f1589ae38a03e25f1a217fdd870b301797"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "92d2c8978df576d27b03b8f806136eaa920329c0fec4f4606f1a07abaad6c353"
  end

  depends_on "openssl@3"

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
    %w[run db/redis log].each { |p| assert_predicate var/p, :exist?, "#{var/p} doesn't exist!" }
  end
end
