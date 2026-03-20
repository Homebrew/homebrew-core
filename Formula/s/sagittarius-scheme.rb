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
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "d503f7f4a9bf5d88253b78a4acca89481bdd7ba73532fb3773b64df7fe60c692"
    sha256 cellar: :any,                 arm64_sequoia: "c1bd54cd081ccb062d90ccd6ffe19374fc8db9711dbc7cd5a10763bde4ad49e3"
    sha256 cellar: :any,                 arm64_sonoma:  "d0ec1780ff4e4a091b6220596a748334a97fdcd7c83eea4224cb328bf749f53f"
    sha256 cellar: :any,                 sonoma:        "22f6d67387b47bbf00765825ec7712299badd39c15158e6136b305055066e142"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "94a20ad75bb3787ac9b9c9244956d13379ce57be536cb35d76a6c6a1a2329a60"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "582e0af6f35a245bb4357f06908eb06913f1a1252e0e62980ba43bcd4669a1b5"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "bdw-gc"
  depends_on "openssl@3"
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
