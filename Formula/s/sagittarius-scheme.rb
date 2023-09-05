class SagittariusScheme < Formula
  desc "Free Scheme implementation supporting R6RS and R7RS"
  homepage "https://bitbucket.org/ktakashi/sagittarius-scheme/wiki/Home"
  url "https://bitbucket.org/ktakashi/sagittarius-scheme/downloads/sagittarius-0.9.10.tar.gz"
  sha256 "17619a6985670c01980e541904685d3c33bc95b795827fad6ba2d22b42f4ccd0"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "c0ffae70fb0e611921b9088b1026edca07b5a7d686d0923a7ec6c68cb45bdaa0"
    sha256 cellar: :any,                 arm64_monterey: "1ca41e363532263fb213e11674f7cc4746e9d575a81c690cd3dba23f84361b2c"
    sha256 cellar: :any,                 arm64_big_sur:  "2b725bb0bebccb87c02fb7463cd6878b2f1aa195b39d45c115a95cd069493e74"
    sha256 cellar: :any,                 ventura:        "9f986220bfe49cf16d2287f1280c257fa4628c7319fcbc3ad6101a4d7a99be59"
    sha256 cellar: :any,                 monterey:       "46709f04e267eeb207bc91100467962b41619cf3fa0591bf58da04f76ee0fed1"
    sha256 cellar: :any,                 big_sur:        "16034beee5e17d474a10bfad137ed058d8ff7d850b8a66706e3b24fc3ea03489"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "af3739934aa6f4a28836a6cd8fb2e80a7a47de62ceca4e83029e1f709a08a8c1"
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
