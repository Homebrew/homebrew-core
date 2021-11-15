class SagittariusScheme < Formula
  desc "Free Scheme implementation supporting R6RS and R7RS"
  homepage "https://bitbucket.org/ktakashi/sagittarius-scheme/wiki/Home"
  url "https://bitbucket.org/ktakashi/sagittarius-scheme/downloads/sagittarius-0.9.8.tar.gz"
  sha256 "09d9c1a53abe734e09762a5f848888f0491516c09cd341a1f9c039cd810d32a2"
  license "BSD-2-Clause"
  revision 1

  bottle do
    sha256 cellar: :any,                 monterey:     "0e3bc5c34bd1acc50c8ba8d98b474c329068d3ff1a911bf1d8d7e3c4f02c115e"
    sha256 cellar: :any,                 big_sur:      "a44076e41f030ddccfed6768ada1ff0201ff6ffb86cce425c3fbabda799883a0"
    sha256 cellar: :any,                 catalina:     "aa2fbe6b306de8d985d0e93f12d9f896b4f7ae5403778508d077bdf975868bcb"
    sha256 cellar: :any,                 mojave:       "dccfa0d38b7096e3c27676fd09d8984009128c1017948d711087dc9d66f44f6f"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "1b527a2abacbc00092ddabd94995149367ac2f388ec739b90a462160d29cbe78"
  end

  depends_on "cmake" => :build
  depends_on "bdw-gc"
  depends_on "libffi"
  depends_on "openssl@1.1"
  depends_on "unixodbc"

  uses_from_macos "zlib"

  def install
    system "cmake", ".", *std_cmake_args, "-DODBC_LIBRARIES=odbc"
    system "make", "install"
  end

  test do
    assert_equal "4", shell_output("#{bin}/sagittarius -e '(display (+ 1 3))(exit)'")
  end
end
