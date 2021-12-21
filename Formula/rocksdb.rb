class Rocksdb < Formula
  desc "Embeddable, persistent key-value store for fast storage"
  homepage "https://rocksdb.org/"
  url "https://github.com/facebook/rocksdb/archive/v6.27.3.tar.gz"
  sha256 "ee29901749b9132692b26f0a6c1d693f47d1a9ed8e3771e60556afe80282bf58"
  license any_of: ["GPL-2.0-only", "Apache-2.0"]
  head "https://github.com/facebook/rocksdb.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "1089d2ad226fe4cbe606357a714f44a0c47c8d1b41e374ca8ab6b58003d588ce"
    sha256 cellar: :any,                 arm64_big_sur:  "ea0179f7a5ba653119b6ad0cb788d6eabe9a9e60e9da664d6eeb6801f2232769"
    sha256 cellar: :any,                 monterey:       "d8e5344ac9d5dad7a019f97df16f4f1b6237c13c2aba5c101336799b5c53404e"
    sha256 cellar: :any,                 big_sur:        "fcde43a1403f2a7b3d6fbe9568826a5bc7c387327e7ae0c52059c6320d063eeb"
    sha256 cellar: :any,                 catalina:       "c9d8b156b0c06ebe348fc9a1f51c34d235f09023d63e92f91c80c6fe9eaa4a83"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "39ba6809d8916dd03f628516d30d1f0a7ac81135aa8fe17414feddebd79c225c"
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
