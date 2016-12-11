class SagittariusScheme < Formula
  desc "Free Scheme implementation supporting R6RS and R7RS"
  homepage "https://bitbucket.org/ktakashi/sagittarius-scheme/wiki/Home"
  url "https://bitbucket.org/ktakashi/sagittarius-scheme/downloads/sagittarius-0.7.10.tar.gz"
  sha256 "b9b3b21bcd96762555c680cbee5bd4875e12e50b51035298aed15298eb6dc02e"
  head "https://bitbucket.org/ktakashi/sagittarius-scheme", :using => :hg

  bottle do
    cellar :any
    sha256 "9803137a6a4a7b9b71381cedcfde4cf02f646acd085e72918ac30d7098840d39" => :sierra
    sha256 "6d5ab721d11b58c023fa3d4b143e3ed4ddd121358c3fc50f38bfec46d0c2b4da" => :el_capitan
    sha256 "7064beb5ba43cbb29058d9dfd2ce79558013decef3d0076a6f2784fef838c538" => :yosemite
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
