class SagittariusScheme < Formula
  desc "Free Scheme implementation supporting R6RS and R7RS"
  homepage "https://bitbucket.org/ktakashi/sagittarius-scheme/wiki/Home"
  url "https://bitbucket.org/ktakashi/sagittarius-scheme/downloads/sagittarius-0.8.9.tar.gz"
  sha256 "8191ce0d61e271744180d9f89dd5a58d19700884b76d62f16dd59cbb84c8afe5"
  revision 1
  head "https://bitbucket.org/ktakashi/sagittarius-scheme", :using => :hg

  bottle do
    cellar :any
    sha256 "a7a531aeb202a2dcba74bc04250ff0b7635eef5f41e65e69f4063dc7a4a7b139" => :high_sierra
    sha256 "0fe1f11fdf6f149cb5cd9ba39d27a9f26fcce0bfd4226eec081c9d8f7d00cc82" => :sierra
    sha256 "e2a7ad03b3100e50829fb6e6f26da1badc40940d4bc6358827cc9dcf1317dea0" => :el_capitan
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
