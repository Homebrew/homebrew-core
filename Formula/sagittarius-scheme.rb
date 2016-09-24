class SagittariusScheme < Formula
  desc "Free Scheme implementation supporting R6RS and R7RS"
  homepage "https://bitbucket.org/ktakashi/sagittarius-scheme/wiki/Home"
  url "https://bitbucket.org/ktakashi/sagittarius-scheme/downloads/sagittarius-0.7.5.tar.gz"
  sha256 "1f51978587d525017d5562148ca966de7de373f129fb6515f479b386ff26e5e6"
  head "https://bitbucket.org/ktakashi/sagittarius-scheme", :using => :hg

  bottle do
    cellar :any
    sha256 "613c2d837619145e52315ae3055de6b179cd1a95f6e13bfe966b2fa2e25390a0" => :el_capitan
    sha256 "e92fea28db89fa22555d6191d0fbfd7e4a8f03e6cd266d74857f829362e3e89e" => :yosemite
    sha256 "3988b42440d76b553a5324c4b14a4cfb41e7f1aec8fb4a5756ebeaa2963f1b2e" => :mavericks
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
