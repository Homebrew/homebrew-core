class SagittariusScheme < Formula
  desc "Free Scheme implementation supporting R6RS and R7RS"
  homepage "https://bitbucket.org/ktakashi/sagittarius-scheme/wiki/Home"
  url "https://bitbucket.org/ktakashi/sagittarius-scheme/downloads/sagittarius-0.8.8.tar.gz"
  sha256 "92ea2de648789e672eed62485a3604a09f35696608d529db2a05f6dd859b28a6"
  head "https://bitbucket.org/ktakashi/sagittarius-scheme", :using => :hg

  bottle do
    cellar :any
    rebuild 1
    sha256 "0f01b52bef8ff6b74761d67dce9c4cccba51b16fbbb19a3899b4c680bd3d94d9" => :high_sierra
    sha256 "ecb1eb25eace5250bb578fa9640edfaa9e16331f6943d0fe7240afbf3aceaa8e" => :sierra
    sha256 "5ee9369f70759998ff7e2d902c31a6c2e2b70d5221a62d507cb286ae4e0aef82" => :el_capitan
    sha256 "459531e572837ed993a8cdee96c2d672d31ebf8fe3458c18036631769c2281d2" => :yosemite
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
