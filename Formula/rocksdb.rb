class Rocksdb < Formula
  desc "Embeddable, persistent key-value store for fast storage"
  homepage "https://rocksdb.org/"
  url "https://github.com/facebook/rocksdb/archive/v6.14.6.tar.gz"
  sha256 "fa61c55735a4911f36001a98aa2f5df1ffe4b019c492133d0019f912191209ce"
  license any_of: ["GPL-2.0-only", "Apache-2.0"]
  revision 1

  bottle do
    cellar :any
    sha256 "f8065a2594655a33d36335f516b0448f2195ba5b4088aa36186b56bf3c1fb989" => :big_sur
    sha256 "a9e2c1d9c7f27200b8ff1483233fdf671665f8bbc5671eeb27875ae20d212e07" => :catalina
    sha256 "629da5a15d3e75afc921716e2c13b5f580444d6c9bf380e3ccb92e215c9978a0" => :mojave
  end

  depends_on "cmake" => :build
  depends_on "gflags"
  depends_on "lz4"
  depends_on "snappy"
  depends_on "zstd"

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  # Add artifact suffix to shared library
  # https://github.com/facebook/rocksdb/pull/7755
  patch do
    url "https://github.com/facebook/rocksdb/commit/98f3f3143007bcb5455105a05da7eeecc9cf53a0.patch?full_index=1"
    sha256 "6fb59cd640ed8c39692855115b72e8aa8db50a7aa3842d53237e096e19f88fc1"
  end

  def install
    ENV.cxx11
    args = std_cmake_args
    args << "-DPORTABLE=ON"
    args << "-DUSE_RTTI=ON"
    args << "-DWITH_BENCHMARK_TOOLS=OFF"
    args << "-DWITH_BZ2=ON"
    args << "-DWITH_LZ4=ON"
    args << "-DWITH_SNAPPY=ON"
    args << "-DWITH_ZLIB=ON"
    args << "-DWITH_ZSTD=ON"

    # build regular rocksdb
    system "cmake", ".", *args
    system "make", "install"

    cd "tools" do
      bin.install "sst_dump" => "rocksdb_sst_dump"
      bin.install "db_sanity_test" => "rocksdb_sanity_test"
      bin.install "write_stress" => "rocksdb_write_stress"
      bin.install "ldb" => "rocksdb_ldb"
      bin.install "db_repl_stress" => "rocksdb_repl_stress"
      bin.install "rocksdb_dump"
      bin.install "rocksdb_undump"
    end
    bin.install "db_stress_tool/db_stress" => "rocksdb_stress"

    # build rocksdb_lite
    args << "-DROCKSDB_LITE=ON"
    args << "-DARTIFACT_SUFFIX=_lite"
    args << "-DWITH_CORE_TOOLS=OFF"
    args << "-DWITH_TOOLS=OFF"
    system "make", "clean"
    system "cmake", ".", *args
    system "make", "install"
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

    extra_args = []
    on_macos do
      extra_args << "-stdlib=libc++"
      extra_args << "-lstdc++"
    end
    system ENV.cxx, "test.cpp", "-o", "db_test", "-v",
                                "-std=c++11",
                                *extra_args,
                                "-lz", "-lbz2",
                                "-L#{lib}", "-lrocksdb_lite",
                                "-DROCKSDB_LITE=1",
                                "-L#{Formula["snappy"].opt_lib}", "-lsnappy",
                                "-L#{Formula["lz4"].opt_lib}", "-llz4",
                                "-L#{Formula["zstd"].opt_lib}", "-lzstd"
    system "./db_test"

    assert_match "sst_dump --file=", shell_output("#{bin}/rocksdb_sst_dump --help 2>&1")
    assert_match "rocksdb_sanity_test <path>", shell_output("#{bin}/rocksdb_sanity_test --help 2>&1", 1)
    assert_match "rocksdb_stress [OPTIONS]...", shell_output("#{bin}/rocksdb_stress --help 2>&1", 1)
    assert_match "rocksdb_write_stress [OPTIONS]...", shell_output("#{bin}/rocksdb_write_stress --help 2>&1", 1)
    assert_match "ldb - RocksDB Tool", shell_output("#{bin}/rocksdb_ldb --help 2>&1")
    assert_match "rocksdb_repl_stress:", shell_output("#{bin}/rocksdb_repl_stress --help 2>&1", 1)
    assert_match "rocksdb_dump:", shell_output("#{bin}/rocksdb_dump --help 2>&1", 1)
    assert_match "rocksdb_undump:", shell_output("#{bin}/rocksdb_undump --help 2>&1", 1)

    db = testpath / "db"
    %w[no snappy zlib bzip2 lz4 zstd].each_with_index do |comp, idx|
      key = "key-#{idx}"
      value = "value-#{idx}"

      put_cmd = "#{bin}/rocksdb_ldb put --db=#{db} --create_if_missing --compression_type=#{comp} #{key} #{value}"
      assert_equal "OK", shell_output(put_cmd).chomp

      get_cmd = "#{bin}/rocksdb_ldb get --db=#{db} #{key}"
      assert_equal value, shell_output(get_cmd).chomp
    end
  end
end
