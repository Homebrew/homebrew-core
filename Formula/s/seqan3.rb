class Seqan3 < Formula
  desc "Modern C++ library for sequence analysis"
  homepage "https://www.seqan.de"
  url "https://github.com/seqan/seqan3/archive/refs/tags/3.4.0.tar.gz"
  sha256 "8e000e6788f1e2ada071b36f64231d56f18e2d687ab4122d86cd3aefc6c87743"
  license all_of: ["BSD-3-Clause", "CC-BY-4.0", "CC0-1.0", "MIT", "Zlib"]

  bottle do
    sha256 cellar: :any_skip_relocation, all: "a635a8d9cfb3c75f5e2372778210d4e955fb600679f52303c325a2124a624bb5"
  end

  depends_on "cereal" => :build
  depends_on "cmake" => :build

  # https://github.com/seqan/seqan3?tab=readme-ov-file#dependencies
  fails_with :clang do
    build 1699
    cause "needs Clang 17 or newer"
  end

  # https://github.com/seqan/seqan3?tab=readme-ov-file#dependencies
  fails_with :gcc do
    version "11"
    cause "needs GCC 12 or newer"
  end

  resource "cmake-scripts" do
    url "https://github.com/seqan/cmake-scripts.git",
        revision: "d2a54ef555b6fc2d496a4c9506dbeb7cf899ce37"
  end

  def install
    resource("cmake-scripts").stage buildpath/"cmake-scripts"

    args = %W[
      -DCPM_USE_LOCAL_PACKAGES=ON
      -DFETCHCONTENT_SOURCE_DIR_USE_CCACHE=#{buildpath}/cmake-scripts
      -DUSE_CCACHE=OFF
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <seqan3/core/debug_stream.hpp>

      int main() {
        seqan3::debug_stream << "Hello World!\\n";
        return 0;
      }
    CPP
    system ENV.cxx, "-std=c++23", "test.cpp", "-o", "test"
    system "./test"
  end
end
