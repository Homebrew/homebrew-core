class SagittariusScheme < Formula
  desc "Free Scheme implementation supporting R6RS and R7RS"
  homepage "https://bitbucket.org/ktakashi/sagittarius-scheme/wiki/Home"
  url "https://bitbucket.org/ktakashi/sagittarius-scheme/downloads/sagittarius-0.8.8.tar.gz"
  sha256 "92ea2de648789e672eed62485a3604a09f35696608d529db2a05f6dd859b28a6"
  head "https://bitbucket.org/ktakashi/sagittarius-scheme", :using => :hg

  bottle do
    cellar :any
    sha256 "83e5cd90728fb89ff065f778a10d8790af99c041939b6b8a3524708fd50d5eeb" => :high_sierra
    sha256 "33d29922c15cbf9699cc9917c28f70d8f7bb9394399a0b8b667ef874b19658a8" => :sierra
    sha256 "e7b3cca78009ee3c86193ef52c134d5ecf25779d57646adef92a881ceade8894" => :el_capitan
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
