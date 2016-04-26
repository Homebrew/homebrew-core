class Rocksdb < Formula
  desc "Persistent key-value store for fast storage environments"
  homepage "http://rocksdb.org"
  url "https://github.com/facebook/rocksdb/archive/v4.5.1.tar.gz"
  sha256 "c6a23a82352dd6bb6bd580db51beafe4c5efa382b16b722c100ce2e7d1a5e497"

  bottle do
    cellar :any
    sha256 "6b766b6f81617902d10642bc360de4beda08c235f2c57511e402d8817e984298" => :el_capitan
    sha256 "ee9217f1a0acf3bfaa1c2bf098eb707d673ba6c8ed885877125ff7efebcc3880" => :yosemite
    sha256 "2e6805b4ee1a5439f7412e04adf927de02180a76e6b4343882672675a1050168" => :mavericks
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
