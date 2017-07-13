class RedisLeveldb < Formula
  desc "Redis-protocol compatible frontend to leveldb"
  homepage "https://github.com/KDr2/redis-leveldb"
  url "https://github.com/KDr2/redis-leveldb/archive/v1.4.tar.gz"
  sha256 "b34365ca5b788c47b116ea8f86a7a409b765440361b6c21a46161a66f631797c"
  revision 3
  head "https://github.com/KDr2/redis-leveldb.git"

  bottle do
    cellar :any
    sha256 "adca2fdf1c56e752b53ca13fa31f0d498ff76ec92fabb2000fd843d7658595c0" => :sierra
    sha256 "99b96a0e61d82ecec7210dd2e867f06d6ae825dec02a91f95d0867594e934c4c" => :el_capitan
    sha256 "a8206064918e6875d7bea5c67dd6ebd757b2a08adb9c93e6569470793c088275" => :yosemite
  end

  depends_on "libev"
  depends_on "gmp"
  depends_on "leveldb"
  depends_on "snappy"

  def install
    inreplace "src/Makefile", "../vendor/libleveldb.a", Formula["leveldb"].opt_lib+"libleveldb.a"
    ENV.prepend "LDFLAGS", "-lsnappy"
    system "make"
    bin.install "redis-leveldb"
  end

  test do
    system "#{bin}/redis-leveldb", "-h"
  end
end
