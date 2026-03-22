class ZlibNg < Formula
  desc "Zlib replacement with optimizations for next generation systems"
  homepage "https://github.com/zlib-ng/zlib-ng"
  url "https://github.com/zlib-ng/zlib-ng/archive/refs/tags/2.3.3.tar.gz"
  sha256 "f9c65aa9c852eb8255b636fd9f07ce1c406f061ec19a2e7d508b318ca0c907d1"
  license "Zlib"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "a87dab0cc6c372a080df58274d8ad4d7d032b447f5feff33d6ce0edbda68cadd"
    sha256 cellar: :any,                 arm64_sequoia: "31190cf145afdde40615ad0b0fb7c054d71017af4d2b2e6912cb42d1798e4cd8"
    sha256 cellar: :any,                 arm64_sonoma:  "2a428652543e36cb95a743249147849805e42392573953fc910714dc10fd6650"
    sha256 cellar: :any,                 sonoma:        "0f6fb50f01003b052ebf7edc658e3e6c2ecaea87458360b3624c04539fc8b04b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dc45b55efd239d80b0ac1122de13d532efc10297cc2cbf8f7379f6f3cc341187"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c99108dad1da97a6929733bf7ed22741197c39e64bd247da00a274eddecb0b1a"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    # https://zlib.net/zlib_how.html
    resource "homebrew-test_artifact" do
      url "https://zlib.net/zpipe.c"
      sha256 "68140a82582ede938159630bca0fb13a93b4bf1cb2e85b08943c26242cf8f3a6"
    end

    # Test uses an example of code for zlib and overwrites its API with zlib-ng API
    testpath.install resource("homebrew-test_artifact")
    inreplace "zpipe.c", "#include \"zlib.h\"", <<~C
      #include "zlib-ng.h"
      #define inflate     zng_inflate
      #define inflateInit zng_inflateInit
      #define inflateEnd  zng_inflateEnd
      #define deflate     zng_deflate
      #define deflateEnd  zng_deflateEnd
      #define deflateInit zng_deflateInit
      #define z_stream    zng_stream
    C

    system ENV.cc, "zpipe.c", "-I#{include}", "-L#{lib}", "-lz-ng", "-o", "zpipe"

    content = "Hello, Homebrew!"
    compressed = pipe_output("./zpipe", content)
    assert_equal content, pipe_output("./zpipe -d", compressed)
  end
end
