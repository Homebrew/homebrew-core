class Rocksdb < Formula
  desc "Embeddable, persistent key-value store for fast storage"
  homepage "https://rocksdb.org/"
  url "https://github.com/facebook/rocksdb/archive/v7.9.2.tar.gz"
  sha256 "886378093098a1b2521b824782db7f7dd86224c232cf9652fcaf88222420b292"
  license any_of: ["GPL-2.0-only", "Apache-2.0"]
  head "https://github.com/facebook/rocksdb.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "86d6086c42b41596f7ada2307676f56c8e0e002d6e00b51c2ace43b0f064e59a"
    sha256 cellar: :any,                 arm64_monterey: "56aa2836bd613d91a37577e03f0f921680e2909dad6415be9f05ebb978dbff88"
    sha256 cellar: :any,                 arm64_big_sur:  "3cd399195acd4c55aaf36bffe0f9f4b5fecd4c49ebba28a5e40e551bc6fdd3de"
    sha256 cellar: :any,                 ventura:        "7f5f34f672fdfe5deb65ff111bc94d5736fb9d0bc9b5ee3857833cc0095bac03"
    sha256 cellar: :any,                 monterey:       "572097b1c71f91bd72ba8433bd78442133d4590c0b406e470b9ad66c526d15cc"
    sha256 cellar: :any,                 big_sur:        "fcd02cefb851fde0327621fe315050e6de9de1bc45cc0269eafca417bec9924f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "282951afeadd54320f61d8f786c6ec8e70881338cec85e2ab089815014666552"
  end

  depends_on "cmake" => :build
  depends_on "gflags"
  depends_on "lz4"
  depends_on "snappy"
  depends_on "zstd"

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  fails_with :gcc do
    version "6"
    cause "Requires C++17 compatible compiler. See https://github.com/facebook/rocksdb/issues/9388"
  end

  def install
    base_args = std_cmake_args + %W[
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

    # build rocksdb_lite
    lite_args = base_args + %w[
      -DROCKSDB_LITE=ON
      -DARTIFACT_SUFFIX=_lite
      -DWITH_CORE_TOOLS=OFF
      -DWITH_TOOLS=OFF
    ]
    mkdir "build_lite" do
      system "cmake", "..", *lite_args
      system "make", "install"
    end
    p = lib/"cmake/rocksdb/RocksDB"
    ["Targets.cmake", "Targets-release.cmake"].each do |s|
      File.rename "#{p}#{s}", "#{p}_Lite#{s}"
    end

    # build regular rocksdb
    mkdir "build" do
      system "cmake", "..", *base_args
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
    if OS.mac?
      extra_args << "-stdlib=libc++"
      extra_args << "-lstdc++"
    end
    system ENV.cxx, "test.cpp", "-o", "db_test", "-v",
                                "-std=c++17",
                                *extra_args,
                                "-lz", "-lbz2",
                                "-L#{lib}", "-lrocksdb",
                                "-L#{Formula["snappy"].opt_lib}", "-lsnappy",
                                "-L#{Formula["lz4"].opt_lib}", "-llz4",
                                "-L#{Formula["zstd"].opt_lib}", "-lzstd"
    system "./db_test"
    system ENV.cxx, "test.cpp", "-o", "db_test_lite", "-v",
                                "-std=c++17",
                                *extra_args,
                                "-lz", "-lbz2",
                                "-L#{lib}", "-lrocksdb_lite",
                                "-DROCKSDB_LITE=1",
                                "-L#{Formula["snappy"].opt_lib}", "-lsnappy",
                                "-L#{Formula["lz4"].opt_lib}", "-llz4",
                                "-L#{Formula["zstd"].opt_lib}", "-lzstd"
    system "./db_test_lite"

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
