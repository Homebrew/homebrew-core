class SagittariusScheme < Formula
  desc "Free Scheme implementation supporting R6RS and R7RS"
  homepage "https://bitbucket.org/ktakashi/sagittarius-scheme/wiki/Home"
  url "https://bitbucket.org/ktakashi/sagittarius-scheme/downloads/sagittarius-0.8.8.tar.gz"
  sha256 "92ea2de648789e672eed62485a3604a09f35696608d529db2a05f6dd859b28a6"
  revision 1
  head "https://bitbucket.org/ktakashi/sagittarius-scheme", :using => :hg

  bottle do
    cellar :any
    sha256 "6015a6aeb8858da6d4f67af465018042f85e26fa5d8ae007f5e8392f39314a20" => :high_sierra
    sha256 "7337b1bccd81962867a23e49c86d2ee90427b4afa8944d9b529855a0f359e364" => :sierra
    sha256 "e6192ba3c46aeceac05db37428592d3598fde788f23c94efdf79ed6131c2a35c" => :el_capitan
  end

  option "without-docs", "Build without HTML docs"

  depends_on "cmake" => :build
  depends_on "libffi"
  depends_on "bdw-gc"

  def install
    arch = MacOS.prefer_64_bit? ? "x86_64" : "x86"

    args = std_cmake_args

    args += %W[
      -DCMAKE_SYSTEM_NAME=darwin
      -DFFI_LIBRARY_DIR=#{Formula["libffi"].lib}
      -DCMAKE_SYSTEM_PROCESSOR=#{arch}
    ]

    system "cmake", *args
    system "make", "doc" if build.with? "docs"
    system "make", "install"
  end

  test do
    assert_equal "4", shell_output("#{bin}/sagittarius -e '(display (+ 1 3))(exit)'")
  end
end
