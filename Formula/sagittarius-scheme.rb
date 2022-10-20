class SagittariusScheme < Formula
  desc "Free Scheme implementation supporting R6RS and R7RS"
  homepage "https://bitbucket.org/ktakashi/sagittarius-scheme/wiki/Home"
  url "https://bitbucket.org/ktakashi/sagittarius-scheme/downloads/sagittarius-0.9.9.tar.gz"
  sha256 "501ecb7f273669f4c8556e522221f15e2db0ca8542d90d82953912390e9498f8"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "aa58043d5a722199e9804c638b9dcd971e1bb581d56949cdd01eda2a6afcc2fe"
    sha256 cellar: :any,                 arm64_big_sur:  "aefe414d8854397b1e9d10af0af06dbbeaaad6ec31fafe15f56041912a221869"
    sha256 cellar: :any,                 monterey:       "8e484bed19b121d1290f9498965d236422548c350150fce878e30831247b0e49"
    sha256 cellar: :any,                 big_sur:        "83e532ea9baf7353b69eee3cef275fde3c6deb35333abbf4982fa92a6c40d9bb"
    sha256 cellar: :any,                 catalina:       "61358c5b04f3fb9acb8752eafb515e1bc6bc1e3054495f974a6376b3dd795249"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1a09b312240733e744a0acbf2257766091c668eed670791f244ee0f492cd0833"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "bdw-gc"
  depends_on "openssl@1.1"
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
