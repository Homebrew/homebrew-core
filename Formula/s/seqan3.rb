class Seqan3 < Formula
  desc "Modern C++ library for sequence analysis"
  homepage "https://www.seqan.de"
  url "https://github.com/seqan/seqan3/releases/download/3.4.2/seqan3-3.4.2-Source.tar.xz"
  sha256 "47568bb116981f06276cec9b433482d38d9b12f5f5d83299734c469eb9d80448"
  license all_of: ["BSD-3-Clause", "CC-BY-4.0", "CC0-1.0", "MIT", "Zlib"]

  bottle do
    sha256 cellar: :any_skip_relocation, all: "499d33a9a9efa955370914435e49c28c4b49c1a688370486edaee273831589f1"
  end

  depends_on "cereal" => :build
  depends_on "cmake" => :build

  on_macos do
    depends_on "gcc" => :test if DevelopmentTools.clang_build_version < 1700
  end

  def install
    args = %w[-DCPM_LOCAL_PACKAGES_ONLY=ON]
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

    ENV.method("gcc-#{Formula["gcc"].version.major}").call if OS.mac? && DevelopmentTools.clang_build_version < 1700
    system ENV.cxx, "-std=c++23", "test.cpp", "-o", "test"
    system "./test"
  end
end
