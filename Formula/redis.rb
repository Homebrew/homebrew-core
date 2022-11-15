class Redis < Formula
  desc "Persistent key-value database, with built-in net interface"
  homepage "https://redis.io/"
  url "https://download.redis.io/releases/redis-7.0.5.tar.gz"
  sha256 "67054cc37b58c125df93bd78000261ec0ef4436a26b40f38262c780e56315cc3"
  license "BSD-3-Clause"
  head "https://github.com/redis/redis.git", branch: "unstable"

  livecheck do
    url "https://download.redis.io/releases/"
    regex(/href=.*?redis[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "a08ad3c26e70d8bb63ae40db29e2c7288bc665239e64d2931b17484830a9a63a"
    sha256 cellar: :any,                 arm64_monterey: "f099e97b8c46be688faba45e0c3dbf35c247c6d6c03a26f5413adb0399bd4d3f"
    sha256 cellar: :any,                 arm64_big_sur:  "e51ccd75da049203010631885f71a57ec02a46a7c4106aa78afb7b4020eb8fb0"
    sha256 cellar: :any,                 ventura:        "6d6472a42256c45b36b094169020a8194daea5f11f1cea30625bd92bd88cf330"
    sha256 cellar: :any,                 monterey:       "34957c1e8e932793ff3d356fe5ae0e1bb36d9f0b6418ef25f0505dd78dc998df"
    sha256 cellar: :any,                 big_sur:        "87968a469cd2ffb2a90b893e580bf4c601b494f02495afe0b62ead25c382fad2"
    sha256 cellar: :any,                 catalina:       "96959c1ff39baf341b92d5818fb9fe29e416b262b7771092f021e5bf31362abf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fbf37524d67381695983be9e1868bc904476cfdbd698adc58631fbff1a224b0e"
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
