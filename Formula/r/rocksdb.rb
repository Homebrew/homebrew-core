class Rocksdb < Formula
  desc "Embeddable, persistent key-value store for fast storage"
  homepage "https://rocksdb.org/"
  url "https://github.com/facebook/rocksdb/archive/refs/tags/v11.1.1.tar.gz"
  sha256 "63f11183fe40725a0e89a9e392f2c86c94b90064f1d95f5173a02cfe40de13f7"
  license any_of: ["GPL-2.0-only", "Apache-2.0"]
  compatibility_version 1
  head "https://github.com/facebook/rocksdb.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "2c467e3e32497d7b2d083df17bce39f38e09cdedaee4e16f4bb6a0537dd0c9c2"
    sha256 cellar: :any,                 arm64_sequoia: "139f202e34c9f459b3100dcdc72941bbbdc4da598e38bc08186027399d48945f"
    sha256 cellar: :any,                 arm64_sonoma:  "889af840722499d72bb196f6cd9eb0263ecab5616767845488dd179609837ff7"
    sha256 cellar: :any,                 sonoma:        "8df51978eb1ac052efb44f2fde78a35b38e72b5e2d00a66c443ac25493e931c7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f9f7f4e2f7382aec8707d84fa049e22355f33631a0fc72b85c218f1e778888c3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "25d9cdc531dc4c60490be75c53fd32d1180df3996894698124ef0cb856ddc410"
  end

  depends_on "cmake" => :build
  depends_on "gflags"
  depends_on "lz4"
  depends_on "snappy"
  depends_on "zstd"

  uses_from_macos "bzip2"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    args = %W[
      -DPORTABLE=ON
      -DUSE_RTTI=ON
      -DWITH_BENCHMARK_TOOLS=OFF
      -DWITH_BZ2=ON
      -DWITH_LZ4=ON
      -DWITH_SNAPPY=ON
      -DWITH_ZLIB=ON
      -DWITH_ZSTD=ON
      -DROCKSDB_BUILD_SHARED=ON
      -DCMAKE_EXE_LINKER_FLAGS=-Wl,-rpath,#{rpath}
      -DZSTD_INCLUDE_DIRS=#{Formula["zstd"].include}
    ]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    cd "build/tools" do
      bin.install "sst_dump" => "rocksdb_sst_dump"
      bin.install "db_sanity_test" => "rocksdb_sanity_test"
      bin.install "write_stress" => "rocksdb_write_stress"
      bin.install "ldb" => "rocksdb_ldb"
      bin.install "db_repl_stress" => "rocksdb_repl_stress"
      bin.install "rocksdb_dump"
      bin.install "rocksdb_undump"
    end
    bin.install "build/db_stress_tool/db_stress" => "rocksdb_stress"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <assert.h>
      #include <rocksdb/options.h>
      #include <rocksdb/memtablerep.h>
      using namespace rocksdb;
      int main() {
        Options options;
        return 0;
      }
    CPP

    extra_args = []
    if OS.mac?
      extra_args << "-stdlib=libc++"
      extra_args << "-lstdc++"
    end
    system ENV.cxx, "test.cpp", "-o", "db_test", "-v",
                                "-std=c++20",
                                *extra_args,
                                "-lz", "-lbz2",
                                "-L#{lib}", "-lrocksdb",
                                "-L#{Formula["snappy"].opt_lib}", "-lsnappy",
                                "-L#{Formula["lz4"].opt_lib}", "-llz4",
                                "-L#{Formula["zstd"].opt_lib}", "-lzstd"
    system "./db_test"

    assert_match "sst_dump <db_dirs_OR_sst_files...>", shell_output("#{bin}/rocksdb_sst_dump --help 2>&1")
    assert_match "rocksdb_sanity_test <path>", shell_output("#{bin}/rocksdb_sanity_test --help 2>&1", 1)
    assert_match "rocksdb_stress [OPTIONS]...", shell_output("#{bin}/rocksdb_stress --help 2>&1", 1)
    assert_match "rocksdb_write_stress [OPTIONS]...", shell_output("#{bin}/rocksdb_write_stress --help 2>&1", 1)
    assert_match "ldb - RocksDB Tool", shell_output("#{bin}/rocksdb_ldb --help 2>&1")
    assert_match "rocksdb_repl_stress:", shell_output("#{bin}/rocksdb_repl_stress --help 2>&1", 1)
    assert_match "rocksdb_dump:", shell_output("#{bin}/rocksdb_dump --help 2>&1", 1)
    assert_match "rocksdb_undump:", shell_output("#{bin}/rocksdb_undump --help 2>&1", 1)

    db = testpath/"db"
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
