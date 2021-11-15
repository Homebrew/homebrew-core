class Rocksdb < Formula
  desc "Embeddable, persistent key-value store for fast storage"
  homepage "https://rocksdb.org/"
  url "https://github.com/facebook/rocksdb/archive/v6.25.3.tar.gz"
  sha256 "ba454cf196281441f205a009e74ca8023cff555cca55869471a59bb29316eb7e"
  license any_of: ["GPL-2.0-only", "Apache-2.0"]
  head "https://github.com/facebook/rocksdb.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "4023032d2e337421e2d28c85002074f1306f6ee92da36309da473e9388e1a8be"
    sha256 cellar: :any,                 arm64_big_sur:  "934e86971a8afcd38ca1434b5d48cc10b1340af1979b9e1b84b7050562f9a925"
    sha256 cellar: :any,                 monterey:       "1f1f9375cb6d7fe00e64ed58c4166eadccb705a70c3da3d84a8353a558ed71a7"
    sha256 cellar: :any,                 big_sur:        "d621a6c84c6ba4c4f1a20bccbb2dcaca48ecb70d948ca7affc32ebc1b497fc40"
    sha256 cellar: :any,                 catalina:       "39db872760c3d295860f704b045d2404855097f2580e73dcf3f21fffab69da71"
    sha256 cellar: :any,                 mojave:         "d422ab75bed6569e2a51d379092463e6068942a410c9c4219367ddac0f4bcbcc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9f420373c850ecb1af37efcc3d28f5bab359a4f379fd8fb5a967b66bcd2661fc"
  end

  depends_on "cmake" => :build
  depends_on "gflags"
  depends_on "lz4"
  depends_on "snappy"
  depends_on "zstd"

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  def install
    ENV.cxx11
    args = std_cmake_args + %W[
      -DPORTABLE=ON
      -DUSE_RTTI=ON
      -DWITH_BENCHMARK_TOOLS=OFF
      -DWITH_BZ2=ON
      -DWITH_LZ4=ON
      -DWITH_SNAPPY=ON
      -DWITH_ZLIB=ON
      -DWITH_ZSTD=ON
      -DCMAKE_EXE_LINKER_FLAGS=-Wl,-rpath,#{rpath}
    ]

    # build regular rocksdb
    mkdir "build" do
      system "cmake", "..", *args
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
    end

    # build rocksdb_lite
    args += %w[
      -DROCKSDB_LITE=ON
      -DARTIFACT_SUFFIX=_lite
      -DWITH_CORE_TOOLS=OFF
      -DWITH_TOOLS=OFF
    ]
    mkdir "build_lite" do
      system "cmake", "..", *args
      system "make", "install"
    end
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
