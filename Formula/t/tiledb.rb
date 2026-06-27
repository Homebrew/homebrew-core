class Tiledb < Formula
  desc "Universal storage engine"
  homepage "https://tiledb.com/"
  url "https://github.com/TileDB-Inc/TileDB/archive/refs/tags/2.30.1.tar.gz"
  sha256 "36381f9eaa2a6defc8990aa1a95d1f0e87971748a50bf6fb705bf032ac7384cf"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "98fee684203c548244cc2f3ec9459f7f4539369e385b3be78240a2ccd30ef106"
    sha256 cellar: :any,                 arm64_sequoia: "c1de4bb360650a489724b55e763de8db121f70ecde9b95e8174fe5af11114715"
    sha256 cellar: :any,                 arm64_sonoma:  "d2486b2bb95402d98de88de5872c2a9339eac39dc80d7d2495cee23b73589ff7"
    sha256 cellar: :any,                 sonoma:        "8c0caf0184e82ca10c8d739210ca07bfc0e2fea6349a04693b2a2ab9b43485e2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bc141748f5b5f2635e77346efcd4cd158ee0b61f71a63d7b816e5deb2cb93421"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "69feef5a67603d461607fba63663fff92e5b955b124675e87e655589a224d2f0"
  end

  depends_on "c-blosc2" => :build
  depends_on "cmake" => :build
  depends_on "nlohmann-json" => :build

  depends_on "fmt"
  depends_on "lz4"
  depends_on "openssl@3"
  depends_on "spdlog"
  depends_on "webp"
  depends_on "zstd"

  uses_from_macos "bzip2"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  # Fix version, remove in next release
  # PR ref: https://github.com/TileDB-Inc/TileDB/pull/5793
  patch do
    url "https://github.com/TileDB-Inc/TileDB/commit/9a89804d24ca736a5baadcc0794c7edede2db1ad.patch?full_index=1"
    sha256 "ea540d60699fc58432ccd0702989bcc1782b5d8f18d64c72548672f54197254b"
  end

  def install
    args = %w[
      -DTILEDB_EXPERIMENTAL_FEATURES=OFF
      -DTILEDB_TESTS=OFF
      -DTILEDB_VERBOSE=ON
      -DTILEDB_WERROR=OFF
      -DTILEDB_DISABLE_AUTO_VCPKG=ON
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <tiledb/tiledb>
      #include <iostream>

      int main() {
        auto [major, minor, patch] = tiledb::version();
        std::cout << major << "." << minor << "." << patch << std::endl;
        return 0;
      }
    CPP
    system ENV.cxx, "test.cpp", "-std=c++17", "-I#{include}", "-L#{lib}", "-ltiledb", "-o", "test"
    assert_match version.to_s, shell_output("./test")
  end
end
