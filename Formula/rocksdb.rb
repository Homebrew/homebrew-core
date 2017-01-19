class Rocksdb < Formula
  desc "Embeddable, persistent key-value store for fast storage"
  homepage "http://rocksdb.org"
  url "https://github.com/facebook/rocksdb/archive/v5.0.2.tar.gz"
  sha256 "5e39d2131ebdb92c30eda3d32861f489f4843fad50cc2fbd5d234bc4415948ca"

  bottle do
    cellar :any
    sha256 "32d3328413cc8765935f716e6c6a861f04d448f3bb006f1349b5afd589884d50" => :sierra
    sha256 "6d17a7867d5f8be0a5481406da94cf84b822e9b81296cb09f7b57cf3de6cfdee" => :el_capitan
    sha256 "d71a0973966e23b217c1b0ff345a945e4dadbc271cb53749afe3a69fc14f8c34" => :yosemite
  end

  option "without-lite", "Don't build mobile/non-flash optimized lite version"
  option "with-tools", "Build tools"

  needs :cxx11
  depends_on "snappy"
  depends_on "lz4"
  depends_on "gflags"

  def install
    ENV.cxx11
    ENV["PORTABLE"] = "1" if build.bottle?
    if build.with? "lite"
      ENV.append_to_cflags "-DROCKSDB_LITE=1"
      ENV["LIBNAME"] = "librocksdb_lite"
    end
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
        return 0;
      }
    EOS

    system ENV.cxx, "test.cpp", "-o", "db_test", "-v",
                                "-std=c++11", "-stdlib=libc++", "-lstdc++",
                                "-lz", "-lbz2",
                                "-L#{lib}", "-lrocksdb_lite",
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
