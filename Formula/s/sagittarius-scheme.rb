class SagittariusScheme < Formula
  desc "Free Scheme implementation supporting R6RS and R7RS"
  homepage "https://github.com/ktakashi/sagittarius-scheme"
  url "https://github.com/ktakashi/sagittarius-scheme/releases/download/v0.9.15/sagittarius-0.9.15.tar.gz"
  sha256 "945f1cf4b4bba4973e996f460e3ade9844314772ce9dc0b29ca51abc5bdaa1b1"
  license "BSD-2-Clause"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_golden_gate: "7baeaf662a002b37223853b74db5e93d1f94b8e7ceffdc00008e796d7f198ee4"
    sha256 cellar: :any, arm64_tahoe:       "272d5089d181b13dbf4aeffe4ad3560ecf96cc7184df76c451109d5f393d8676"
    sha256 cellar: :any, arm64_sequoia:     "412ebad082c2d968dade069d7a40f8048ca397d04373a9a24b3e20b237a1439b"
    sha256 cellar: :any, arm64_linux:       "3bada512c4187f602c78b79f971c6dc16e5f807bf6cb7562d27a6ce34c16bbe1"
    sha256 cellar: :any, x86_64_linux:      "a9eec431f1fae56d9c9900fbcf5abef96f044960449b4353b047f2332b36829d"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "bdw-gc"
  depends_on "openssl@4"
  depends_on "unixodbc"

  uses_from_macos "libffi"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    # Work around build error on Apple Silicon by forcing little endian.
    # src/sagittarius/private/sagittariusdefs.h:200:3: error: Failed to detect endian
    ENV.append_to_cflags "-D_LITTLE_ENDIAN" if OS.mac? && Hardware::CPU.arm?

    system "cmake", "-S", ".", "-B", "build", "-DODBC_LIBRARIES=odbc", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    assert_equal "4", shell_output("#{bin}/sagittarius -e '(display (+ 1 3))(exit)'")
  end
end
