class Rocksdb < Formula
  desc "Persistent key-value store for fast storage environments"
  homepage "http://rocksdb.org"
  url "https://github.com/facebook/rocksdb/archive/v4.6.1.tar.gz"
  sha256 "b6cf3d99b552fb5daae4710952640810d3d810aa677821a9c7166a870669c572"

  bottle do
    cellar :any
    sha256 "38b429e820dfd245e976e0ffaff64f1e03ac34d3823c8711fe8d2ef9efde8eab" => :el_capitan
    sha256 "c9eb8cc6b8a9de18abc275ff64d6ea8ef778afb76e4f8bcf925f5763e89b51d1" => :yosemite
    sha256 "f203eb0a7d99c81584292e2ce317f5121d0771d18803e1c1154dbb0a9d034e90" => :mavericks
  end

  option "with-lite", "Build mobile/non-flash optimized lite version"

  needs :cxx11
  depends_on "snappy"
  depends_on "lz4"

  def install
    ENV.cxx11
    ENV["PORTABLE"] = "1" if build.bottle?
    ENV.append_to_cflags "-DROCKSDB_LITE=1" if build.with? "lite"
    system "make", "clean"
    system "make", "static_lib"
    system "make", "shared_lib"
    system "make", "install", "INSTALL_PATH=#{prefix}"
  end

  test do
    (testpath/"test.cpp").write <<-EOS.undent
      #include <assert.h>
      #include <rocksdb/options.h>
      #include <rocksdb/memtablerep.h>
      using namespace rocksdb;
      int main() {
        Options options;
        options.memtable_factory.reset(
                    NewHashSkipListRepFactory(16));
        return 0;
      }
    EOS

    system ENV.cxx, "test.cpp", "-o", "db_test", "-v", "-std=c++11",
                                "-stdlib=libc++",
                                "-lstdc++",
                                "-lrocksdb",
                                "-lz", "-lbz2",
                                "-lsnappy", "-llz4"
    system "./db_test"
  end
end
