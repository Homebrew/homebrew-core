class Rocksdb < Formula
  desc "Embeddable, persistent key-value store for fast storage"
  homepage "https://rocksdb.org/"
  url "https://github.com/facebook/rocksdb/archive/v6.27.3.tar.gz"
  sha256 "ee29901749b9132692b26f0a6c1d693f47d1a9ed8e3771e60556afe80282bf58"
  license any_of: ["GPL-2.0-only", "Apache-2.0"]
  revision 1
  head "https://github.com/facebook/rocksdb.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "816b027a2530246f7681f107ac6d4ad0df5a0818bd06097d4b9be6d611d18df0"
    sha256 cellar: :any,                 arm64_big_sur:  "f2b5379c5f04163d5a84a12dfcb54abf3d120df7ffd415e1524455d9a53eff45"
    sha256 cellar: :any,                 monterey:       "b69c583b06da21652e043d04fc2a6a8d2b66e649525eeecbbc8d9612b2fb9781"
    sha256 cellar: :any,                 big_sur:        "f4ffe938c9e14dec2e7c143400ee724720ac0287239fdd0e21676cd6b2c70cae"
    sha256 cellar: :any,                 catalina:       "cf574fc011d4f65d79c1dc479f5b9bb77edbcc719926bae2190dfc5d6734de10"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d1a3c85437ee67fb23f98944f487cbdd2e267974150b1d363181a7b8a16a99a6"
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
    on_macos do
      extra_args << "-stdlib=libc++"
      extra_args << "-lstdc++"
    end
    system ENV.cxx, "test.cpp", "-o", "db_test", "-v",
                                "-std=c++11",
                                *extra_args,
                                "-lz", "-lbz2",
                                "-L#{lib}", "-lrocksdb",
                                "-L#{Formula["snappy"].opt_lib}", "-lsnappy",
                                "-L#{Formula["lz4"].opt_lib}", "-llz4",
                                "-L#{Formula["zstd"].opt_lib}", "-lzstd"
    system "./db_test"
    system ENV.cxx, "test.cpp", "-o", "db_test_lite", "-v",
                                "-std=c++11",
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
