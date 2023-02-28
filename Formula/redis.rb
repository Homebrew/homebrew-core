class Redis < Formula
  desc "Persistent key-value database, with built-in net interface"
  homepage "https://redis.io/"
  url "https://download.redis.io/releases/redis-7.0.9.tar.gz"
  sha256 "f77135c2a47c9151d4028bfea3b34470ab4d324d1484f79a84c6f32a3cfb9f65"
  license "BSD-3-Clause"
  head "https://github.com/redis/redis.git", branch: "unstable"

  livecheck do
    url "https://download.redis.io/releases/"
    regex(/href=.*?redis[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "b125a93249828be3359621e6e157d8ad6070906684e0ae740543ae208edccf21"
    sha256 cellar: :any,                 arm64_monterey: "9fcb85f77bfe0681476daffea5fcbbf87d188269a7e407422c87507b536ecf36"
    sha256 cellar: :any,                 arm64_big_sur:  "a58acadd484dd8dbb49add355670c249b3b09bf233e443b6f6ebedbf22ec9bf2"
    sha256 cellar: :any,                 ventura:        "1dc964bfdd067d744f100d0572529c204b5e5f7e2da703eb2d3d063ceb06ac54"
    sha256 cellar: :any,                 monterey:       "26529b9a45bac464c161df9204f9330ed35cc2b8a4c330bf3288999716baf42e"
    sha256 cellar: :any,                 big_sur:        "a6ec711360b6c70fd93d3db044316374ca0d6d83b44477f3798c1d1358b497ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c0b8818655e481020f8180bda9d05284b709c5764c91f98f4324a752e60a9113"
  end

  depends_on "openssl@1.1"

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
    %w[run db/redis log].each { |p| assert_predicate var/p, :exist?, "#{var/p} doesn't exist!" }
  end
end
