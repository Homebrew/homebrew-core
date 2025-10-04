class SagittariusScheme < Formula
  desc "Free Scheme implementation supporting R6RS and R7RS"
  homepage "https://github.com/ktakashi/sagittarius-scheme"
  url "https://github.com/ktakashi/sagittarius-scheme/releases/download/v0.9.13/sagittarius-0.9.13.tar.gz"
  sha256 "8cf812190c43738a9d6021e677c928a80c05cad1a03047c1868c865ccfd65773"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "f2233759c744b4306a29c889f1353eb79d3ef63eb28ca67b04b5236adb4b108b"
    sha256 cellar: :any,                 arm64_sequoia: "1a2a574e1ab887938910ae732c2361f97dd66a8781c0844f1272b48ad5c75ded"
    sha256 cellar: :any,                 arm64_sonoma:  "b126aaf308f762b129314b25859c99a8c9cfd3fc8ba0bb66e136da369e98003e"
    sha256 cellar: :any,                 arm64_ventura: "20f8fcc41f81fd346abc1a3e1aab0965e9ee575566acc9f61878188c3006b2a2"
    sha256 cellar: :any,                 sonoma:        "70e046b1c40141507915325710175d48ce28c80eb6ed7ab0cdb478c0962d78b0"
    sha256 cellar: :any,                 ventura:       "a6b58821c02c1f395ca5002a0c8c55c6cb531de4682a6166ef4c2963dfe8212a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0a90dbb17deb8e950e169ff7c53b64e6258bcd890051946d61afe06d5f78edce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8f0455c78b4d9b9df71d6863aa5bdbff00c3869878b3b0a80f1fcd76509b020d"
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
