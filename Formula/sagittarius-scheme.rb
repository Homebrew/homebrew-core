class SagittariusScheme < Formula
  desc "Free Scheme implementation supporting R6RS and R7RS"
  homepage "https://bitbucket.org/ktakashi/sagittarius-scheme/wiki/Home"
  url "https://bitbucket.org/ktakashi/sagittarius-scheme/downloads/sagittarius-0.9.8.tar.gz"
  sha256 "09d9c1a53abe734e09762a5f848888f0491516c09cd341a1f9c039cd810d32a2"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 big_sur:      "cf0368881b0be31b65715e3666aa1e98f57967c82cb10a9079bd47683796b4de"
    sha256 cellar: :any,                 catalina:     "347eb95c934f3630ce8ff5f3c4a8512df5863c0735e088ecb40135f247c785d7"
    sha256 cellar: :any,                 mojave:       "80ebf0f56a95c5652e8ff3bf2e975ced7cf3118b2abbfb51b23cb1c2969c8ca4"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "fa4f304d850b58800717c1c9b2ba276fa083fb37e4c17339cadcce63c46503f7"
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
