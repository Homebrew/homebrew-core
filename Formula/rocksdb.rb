class Rocksdb < Formula
  desc "Persistent key-value store for fast storage environments"
  homepage "http://rocksdb.org"
  url "https://github.com/facebook/rocksdb/archive/v4.11.2.tar.gz"
  sha256 "9374be06fdfccbbdbc60de90b72b5db7040e1bc4e12532e4c67aaec8181b45be"

  bottle do
    cellar :any
    sha256 "7d5f7521c94733aae409b1debba32d28a0ac4866b1f0871b03030aa271f45bba" => :sierra
    sha256 "0ed1658ca1eb9f3c256192b9eeb7a227bcffa6b5de5d05eefa49f80b20820919" => :el_capitan
    sha256 "7d0ce20065fce6fe3f3acff398853f19cb24ab463728f0277fc404a20c15023d" => :yosemite
    sha256 "975a16f79fbc94a8ec5977d167d90be82c8779ad015824423de1fac856e5fd93" => :mavericks
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

    system ENV.cxx, "test.cpp", "-o", "db_test", "-v",
                                "-std=c++11", "-stdlib=libc++", "-lstdc++",
                                "-lz", "-lbz2",
                                "-L#{lib}", "-lrocksdb",
                                "-L#{Formula["snappy"].opt_lib}", "-lsnappy",
                                "-L#{Formula["lz4"].opt_lib}", "-llz4"
    system "./db_test"
  end
end
