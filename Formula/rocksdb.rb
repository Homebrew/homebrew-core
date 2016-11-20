class Rocksdb < Formula
  desc "Embeddable, persistent key-value store for fast storage"
  homepage "http://rocksdb.org"
  url "https://github.com/facebook/rocksdb/archive/v4.11.2.tar.gz"
  sha256 "9374be06fdfccbbdbc60de90b72b5db7040e1bc4e12532e4c67aaec8181b45be"

  bottle do
    cellar :any
    rebuild 1
    sha256 "df25c15c8f1a4b41ff5e5273fa8c3c21a186b9241c5cfce0226f4ef6f58e8b36" => :sierra
    sha256 "0bfffdb6a3ad9b446a9d8936e43462adaa6c2195f70068c43785feed4bef537d" => :el_capitan
    sha256 "c2a7a1f67add41b293cf5b059b9eef93f641f00c4c2e286b48973b887ebfbe3c" => :yosemite
  end

  option "with-lite", "Build mobile/non-flash optimized lite version"
  option "with-tools", "Build tools"

  needs :cxx11
  depends_on "snappy"
  depends_on "lz4"
  depends_on "gflags" if build.with? "lite"

  def install
    ENV.cxx11
    ENV["PORTABLE"] = "1" if build.bottle?
    ENV.append_to_cflags "-DROCKSDB_LITE=1" if build.with? "lite"
    system "make", "clean"
    system "make", "static_lib"
    system "make", "shared_lib"
    system "make", "tools" if build.with? "tools"
    system "make", "install", "INSTALL_PATH=#{prefix}"
    if build.with? "tools"
      bin.install "sst_dump" => "rocksdb_sst_dump"
      bin.install "db_sanity_test" => "rocksdb_sanity_test"
      bin.install "db_stress" => "rocksdb_stress"
      bin.install "write_stress" => "rocksdb_write_stress"
      bin.install "ldb" => "rocksdb_ldb"
      bin.install "db_repl_stress" => "rocksdb_repl_stress"
      bin.install "rocksdb_dump"
      bin.install "rocksdb_undump"
    end
  end

  test do
    (testpath/"test.cpp").write <<-EOS.undent
      #include <assert.h>
      #include <rocksdb/options.h>
      #include <rocksdb/memtablerep.h>
      using namespace rocksdb;
      int main() {
        Options options;
        options.memtable_factory.reset(NewHashSkipListRepFactory(16));
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

    if build.with? "tools"
      system "#{bin}/rocksdb_sst_dump", "--help"
      system "#{bin}/rocksdb_sanity_test", "--help"
      system "#{bin}/rocksdb_stress", "--help"
      system "#{bin}/rocksdb_write_stress", "--help"
      system "#{bin}/rocksdb_ldb", "--help"
      system "#{bin}/rocksdb_repl_stress", "--help"
      system "#{bin}/rocksdb_dump", "--help"
      system "#{bin}/rocksdb_undump", "--help"
    end
  end
end
