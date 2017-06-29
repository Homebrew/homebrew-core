class RedisLeveldb < Formula
  desc "Redis-protocol compatible frontend to leveldb"
  homepage "https://github.com/KDr2/redis-leveldb"
  url "https://github.com/KDr2/redis-leveldb/archive/v1.4.tar.gz"
  sha256 "b34365ca5b788c47b116ea8f86a7a409b765440361b6c21a46161a66f631797c"
  revision 2
  head "https://github.com/KDr2/redis-leveldb.git"

  bottle do
    cellar :any
    sha256 "a08edcd652cdc842d61081caa5aaef6078735951f77c8c29711e3ddfbc3652d7" => :sierra
    sha256 "8ba3949a7b45b0b94699988ea45b3113165d1ef21307598e2015789a5d25791e" => :el_capitan
    sha256 "e7b2e352b0ff1e65cf768b5219b5ea2ae729240e8004c936792788f72d6a2b76" => :yosemite
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
