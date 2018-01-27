class SagittariusScheme < Formula
  desc "Free Scheme implementation supporting R6RS and R7RS"
  homepage "https://bitbucket.org/ktakashi/sagittarius-scheme/wiki/Home"
  url "https://bitbucket.org/ktakashi/sagittarius-scheme/downloads/sagittarius-0.8.9.tar.gz"
  sha256 "8191ce0d61e271744180d9f89dd5a58d19700884b76d62f16dd59cbb84c8afe5"
  revision 1
  head "https://bitbucket.org/ktakashi/sagittarius-scheme", :using => :hg

  bottle do
    cellar :any
    sha256 "7b200a64350627048d97e543f582f59fcf905090f9021dd76bdeed0f923a91df" => :high_sierra
    sha256 "d2d7a1d0c8fb59f2c89da47eabb7cf74c95cba7901aad088e4a100ee779475ed" => :sierra
    sha256 "551bfeff31febb60604e2abf71e23677dc7635878f0198f9a32320b7aa7aec6b" => :el_capitan
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
