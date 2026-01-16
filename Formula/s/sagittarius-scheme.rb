class SagittariusScheme < Formula
  desc "Free Scheme implementation supporting R6RS and R7RS"
  homepage "https://github.com/ktakashi/sagittarius-scheme"
  url "https://github.com/ktakashi/sagittarius-scheme/releases/download/v0.9.14/sagittarius-0.9.14.tar.gz"
  sha256 "2f464a0a249b9de59ed7e7338fcdf1f9b0873d9c35bae612749c0a1e9e2a4e79"
  license "BSD-2-Clause"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "1cb98830feaedcb69a562e8bd26bdf1daf75727f9e7d9b1b8f07a1ebed6bb70d"
    sha256 cellar: :any,                 arm64_sequoia: "ecfa692112d5f7ed323514966d439476328d4bcfa051437566d1b27c06565827"
    sha256 cellar: :any,                 arm64_sonoma:  "0b3c3c3de1b4b0f765a988fcedc436cea4afb2213c8a93f32efdf83291f7b598"
    sha256 cellar: :any,                 sonoma:        "73859b41b1c57444c735d6b951ab619c4ee1f156502ead10fb20aadb83394145"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1ce23bb1611d8dd26758aa34956309ee7cda23b8ca8762f38dadce61703835e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c44c06e01d0857f84af6d255dccd3eae30e19ae5fe25d2ae9030aae155adf7d9"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "bdw-gc"
  depends_on "openssl@3"
  depends_on "unixodbc"

  uses_from_macos "libffi"
  uses_from_macos "zlib"

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
