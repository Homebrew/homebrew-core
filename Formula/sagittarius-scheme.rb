class SagittariusScheme < Formula
  desc "Free Scheme implementation supporting R6RS and R7RS"
  homepage "https://bitbucket.org/ktakashi/sagittarius-scheme/wiki/Home"
  url "https://bitbucket.org/ktakashi/sagittarius-scheme/downloads/sagittarius-0.9.4.tar.gz"
  sha256 "0a8fd767c19c7d784448b68c03a241ebacba5bbcd177c0cbda0164807d9ef7f2"

  bottle do
    cellar :any
    sha256 "104a20fb10f9915b11ca461d5c701c69053c952b7ac095f2724dec25a17c6543" => :mojave
    sha256 "c456079b9e99890b63a4d53d6d9e378df9b580f3f2a7d5b22ad40c1c8ad482a1" => :high_sierra
    sha256 "8c3bd3c8fabe8b6ac581af8406d198fd5531adff2b1851c4fdb4e74feef263f1" => :sierra
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
