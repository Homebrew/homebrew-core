class Rocksdb < Formula
  desc "Embeddable, persistent key-value store for fast storage"
  homepage "https://rocksdb.org/"
  url "https://github.com/facebook/rocksdb/archive/v6.1.2.tar.gz"
  sha256 "df93f3b66caa1cbe1c2862c99c33e18a5c5b24a64fb51dfe8ef805e3c9fd1cad"

  bottle do
    cellar :any
    sha256 "c4263cba90140e0353fa89120e37ee541c6a65d89d79bc5ad94314e782262e30" => :mojave
    sha256 "952b3fd45590fc8592cf6f5d945ac27f82126730c02ccc61efe86d7911554206" => :high_sierra
    sha256 "86792cf15a7d20c03f15d1e2dfb40e3abe8407ace76a9436ec47db7f349b52ef" => :sierra
  end

  depends_on "gflags"
  depends_on "lz4"
  depends_on "snappy"

  def install
    ENV.cxx11
    ENV["PORTABLE"] = "1"
    ENV["DEBUG_LEVEL"] = "0"
    ENV["USE_RTTI"] = "1"
    ENV["ROCKSDB_DISABLE_ALIGNED_NEW"] = "1" if MacOS.version <= :sierra
    ENV["DISABLE_JEMALLOC"] = "1" # prevent opportunistic linkage

    # build regular rocksdb
    system "make", "clean"
    system "make", "static_lib"
    system "make", "shared_lib"
    system "make", "tools"
    system "make", "install", "INSTALL_PATH=#{prefix}"

    bin.install "sst_dump" => "rocksdb_sst_dump"
    bin.install "db_sanity_test" => "rocksdb_sanity_test"
    bin.install "db_stress" => "rocksdb_stress"
    bin.install "write_stress" => "rocksdb_write_stress"
    bin.install "ldb" => "rocksdb_ldb"
    bin.install "db_repl_stress" => "rocksdb_repl_stress"
    bin.install "rocksdb_dump"
    bin.install "rocksdb_undump"

    # build rocksdb_lite
    ENV.append_to_cflags "-DROCKSDB_LITE=1"
    ENV["LIBNAME"] = "librocksdb_lite"
    system "make", "clean"
    system "make", "static_lib"
    system "make", "shared_lib"
    system "make", "install", "INSTALL_PATH=#{prefix}"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
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

    assert_match "sst_dump --file=", shell_output("#{bin}/rocksdb_sst_dump --help 2>&1", 1)
    assert_match "rocksdb_sanity_test <path>", shell_output("#{bin}/rocksdb_sanity_test --help 2>&1", 1)
    assert_match "rocksdb_stress [OPTIONS]...", shell_output("#{bin}/rocksdb_stress --help 2>&1", 1)
    assert_match "rocksdb_write_stress [OPTIONS]...", shell_output("#{bin}/rocksdb_write_stress --help 2>&1", 1)
    assert_match "ldb - RocksDB Tool", shell_output("#{bin}/rocksdb_ldb --help 2>&1", 1)
    assert_match "rocksdb_repl_stress:", shell_output("#{bin}/rocksdb_repl_stress --help 2>&1", 1)
    assert_match "rocksdb_dump:", shell_output("#{bin}/rocksdb_dump --help 2>&1", 1)
    assert_match "rocksdb_undump:", shell_output("#{bin}/rocksdb_undump --help 2>&1", 1)
  end
end
