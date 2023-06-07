class SagittariusScheme < Formula
  desc "Free Scheme implementation supporting R6RS and R7RS"
  homepage "https://bitbucket.org/ktakashi/sagittarius-scheme/wiki/Home"
  url "https://bitbucket.org/ktakashi/sagittarius-scheme/downloads/sagittarius-0.9.9.tar.gz"
  sha256 "501ecb7f273669f4c8556e522221f15e2db0ca8542d90d82953912390e9498f8"
  license "BSD-2-Clause"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "237ea12128152a7f632b5ed43aceddb28995f8799067f13fa054a081cff466e6"
    sha256 cellar: :any,                 arm64_monterey: "937526c62057dab00ce297beac5d106d3aa2268ebda9a2753a873427e8727e2f"
    sha256 cellar: :any,                 arm64_big_sur:  "928d29bdbc346929358499d1adc55f4cc904d15fd4863580af2c9ebf11c3f57f"
    sha256 cellar: :any,                 ventura:        "346109597d535794bfeea71fce3a280c2e73138ed1e0cfea02151f3784a57a44"
    sha256 cellar: :any,                 monterey:       "151832417b0a270f1b11d1549fff12dfdd81b50eafbf8dedffb8a43e63e9c57f"
    sha256 cellar: :any,                 big_sur:        "f0795af1db94d8df817ad6b70f5b2c85699f7a404dc24bb388f37ad3e4b38ad9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4825f62883dba6d3d4409a46948aef4fc6ca07f9ce2a715545d1f9413f4ad696"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "bdw-gc"
  depends_on "openssl@3"
  depends_on "unixodbc"

  uses_from_macos "libffi", since: :catalina
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
