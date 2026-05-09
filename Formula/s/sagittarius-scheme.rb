class SagittariusScheme < Formula
  desc "Free Scheme implementation supporting R6RS and R7RS"
  homepage "https://github.com/ktakashi/sagittarius-scheme"
  url "https://github.com/ktakashi/sagittarius-scheme/releases/download/v0.9.14/sagittarius-0.9.14.tar.gz"
  sha256 "2f464a0a249b9de59ed7e7338fcdf1f9b0873d9c35bae612749c0a1e9e2a4e79"
  license "BSD-2-Clause"
  revision 1

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "ad5004fa271ebcaa7519e492b83d48a76b7250f76d4073fc094a4428699f89b6"
    sha256 cellar: :any,                 arm64_sequoia: "90ea14cc78c6637f0cb2a1f579588240557b7f3c13c020356320be5eae3a70e0"
    sha256 cellar: :any,                 arm64_sonoma:  "b6eeff24a55efe3434fe40a606eb31678ee5be6c16ad8a4e509c9410d45f6975"
    sha256 cellar: :any,                 sonoma:        "7af7102f09f4b90f602150606ac082e1cc12f0bd9c11b5e19c9d271148d098c2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6577a128adc9ea05588f5eba70bbd2f91cb9b2595f249c3e41fb37c10c448041"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bbd1c66405bcc43eac8afc154d3a9063d40729a72a33513c8ef8c6662fda9c4a"
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
