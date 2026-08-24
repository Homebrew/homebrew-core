class SagittariusScheme < Formula
  desc "Free Scheme implementation supporting R6RS and R7RS"
  homepage "https://github.com/ktakashi/sagittarius-scheme"
  url "https://github.com/ktakashi/sagittarius-scheme/releases/download/v0.9.15/sagittarius-0.9.15.zip"
  sha256 "81044f1dfe567125bf83f18f21d2c31a4c9c6b476a2d8e63d7547fe1bdb8d4e4"
  license "BSD-2-Clause"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "4b5179ebf49b9a7b9b0ce0b9c88a3b90470875dfdc351c73ce2341b3c701a43b"
    sha256 cellar: :any, arm64_sequoia: "69fd440a93deb6eb0691814116e8e4c049faf2c85ce4bffa09ab8fbe873f1329"
    sha256 cellar: :any, arm64_sonoma:  "5aa56c2bf406cab788092245c9311d93e6d2f5a42b4d72b65bdb933a677ef453"
    sha256 cellar: :any, sonoma:        "57191c461ca4d5e3ecd7676a788dfa0d6c3042e22e632c1930ce5584fefa72d8"
    sha256 cellar: :any, arm64_linux:   "2ef225fb754ce2915909159c4bc9c0b80fcb547113f698cd5d74abef8e014572"
    sha256 cellar: :any, x86_64_linux:  "93776c5c3618e967f0ef36cad2f2abf1c3a730b4d32a1dc72ab3475b95bea206"
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
