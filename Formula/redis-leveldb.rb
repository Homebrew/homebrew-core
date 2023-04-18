class RedisLeveldb < Formula
  desc "Redis-protocol compatible frontend to leveldb"
  homepage "https://github.com/KDr2/redis-leveldb"
  url "https://github.com/KDr2/redis-leveldb/archive/v1.4.tar.gz"
  sha256 "b34365ca5b788c47b116ea8f86a7a409b765440361b6c21a46161a66f631797c"
  license "MIT"
  revision 3
  head "https://github.com/KDr2/redis-leveldb.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "14e20960b64bbccf61906791c432997c805a853eee48593f9d7881490e71d403"
    sha256 cellar: :any,                 arm64_monterey: "3924d88c6a1080614983fcd3840adeccb78b9cbc0392c62d543edd966c4e9e43"
    sha256 cellar: :any,                 arm64_big_sur:  "5e41ff1939788e1fa297df8345b1c515b4bdaf046fa7c0d54e853aa1f0030dc1"
    sha256 cellar: :any,                 ventura:        "71c8f543584e25088c9d42c8cf0a872fb941ecfba54e0627f0e4eaca7ff9b6e9"
    sha256 cellar: :any,                 monterey:       "eaf9d161468a86bc6d97e60bec55862eaee573b526c290de859e48cf1dbe5248"
    sha256 cellar: :any,                 big_sur:        "ca866ff83813a3d7a06626608016aba38a40bd1e813f04079dd2221f5740336b"
    sha256 cellar: :any,                 catalina:       "d1c4da1f1f3e3afec9ec5d345743f9d49e85615fa3ffde619bad13e479ce670a"
    sha256 cellar: :any,                 mojave:         "f2345f0e55d37343c3c7e2fb4c43e517d429db2bb284430d3db1222675b8b520"
    sha256 cellar: :any,                 high_sierra:    "9efe9023206565f3d5557202465fa99440262aef2298894c1f738dba0a39ad10"
    sha256 cellar: :any,                 sierra:         "c8cdcf2f80de6eda4f86e9a7c6726ef1a2e046378a28b72b52deb180a15d1916"
    sha256 cellar: :any,                 el_capitan:     "5373414613caf193828f782883f835858a8c999943a542e9ec3ff735a918bb63"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1723583af723d8a9d13f45b476071b70bac6c509f96e9ffba3d975f45ca4e521"
  end

  depends_on "gmp"
  depends_on "leveldb"
  depends_on "libev"
  depends_on "snappy"

  def install
    inreplace "src/Makefile", "../vendor/libleveldb.a", Formula["leveldb"].opt_lib/"libleveldb.a"
    ENV.prepend "LDFLAGS", "-lsnappy"
    system "make"
    bin.install "redis-leveldb"
  end

  test do
    system "#{bin}/redis-leveldb", "-h"
  end
end
