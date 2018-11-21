class SagittariusScheme < Formula
  desc "Free Scheme implementation supporting R6RS and R7RS"
  homepage "https://bitbucket.org/ktakashi/sagittarius-scheme/wiki/Home"
  url "https://bitbucket.org/ktakashi/sagittarius-scheme/downloads/sagittarius-0.9.4.tar.gz"
  sha256 "0a8fd767c19c7d784448b68c03a241ebacba5bbcd177c0cbda0164807d9ef7f2"

  bottle do
    cellar :any
    sha256 "b8ab79dd3b453a500980c2093dbc36ab9165a648b7a23ad536962c23d826d3cf" => :mojave
    sha256 "50a992385f4b92f1653edd90b233d09d1e3887cb4a38c010658567b3031f8f50" => :high_sierra
    sha256 "c7b516b40848c0ec95d2147922654542c5a29c38041e1b1f495f6ead0d3328ad" => :sierra
    sha256 "67f26c0ec6fc2f7b5dccfd9b2050ae16b04f8b26c9baf416a866dcac2475e1a5" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "bdw-gc"
  depends_on "libffi"
  depends_on "openssl"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    assert_equal "4", shell_output("#{bin}/sagittarius -e '(display (+ 1 3))(exit)'")
  end
end
