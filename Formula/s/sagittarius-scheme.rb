class SagittariusScheme < Formula
  desc "Free Scheme implementation supporting R6RS and R7RS"
  homepage "https://bitbucket.org/ktakashi/sagittarius-scheme/wiki/Home"
  url "https://bitbucket.org/ktakashi/sagittarius-scheme/downloads/sagittarius-0.9.11.tar.gz"
  sha256 "b3ec4c1bcc46e78539e621e2afbf522e5f6d43c042d4235c2c3c597ef453cb66"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "7f1cb7d370b52c2227c80a7f62b37840f8ea8df7599c7c8d50eea067e2ddf59e"
    sha256 cellar: :any,                 arm64_ventura:  "90beda0fadc72cd8b29fd89ede86a2949d301a30fec49b379137e469d62128cc"
    sha256 cellar: :any,                 arm64_monterey: "2105b18cd2da34618619f9208e7580e4962d926e171039d9e69fe392a6f087ff"
    sha256 cellar: :any,                 sonoma:         "1dedfcc2e538adbf418bc960d5c1cfc06869f94d53c18aadc0947a5dd37520b8"
    sha256 cellar: :any,                 ventura:        "841e434e3f497b5f0995f647743569f902874f373b81bbbe04faa52a35c22dfe"
    sha256 cellar: :any,                 monterey:       "70c2204bbd2f27882c20a3d448cf4f66d93676d2ea6289be4afe92b1d5465af9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d14d120ab7276dccad71129c24ccac4760dc929e801e471f7d3d439801972bdb"
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
