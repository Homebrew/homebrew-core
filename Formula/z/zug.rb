class Zug < Formula
  desc "C++ library providing transducers"
  homepage "https://sinusoid.es/zug/"
  url "https://github.com/arximboldi/zug/archive/refs/tags/v0.1.2.tar.gz"
  sha256 "75ff666a4ce1615b3ca26abbb17b10f5cb5cf5f86c9c293ec430c34750d3ea27"
  license "BSL-1.0"
  head "https://github.com/arximboldi/zug.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "e3834dddcd9eb7036a9a75ea740f0498c6566cfb6dec6f3d20e488b7f4881f96"
  end

  depends_on "cmake" => :build

  def install
    args = %w[
      -Dzug_BUILD_EXAMPLES=OFF
      -Dzug_BUILD_TESTS=OFF
    ]
    system "cmake", "-S", ".", "-B", "_build", *args, *std_cmake_args.reject { |s| s["-DBUILD_TESTING=OFF"] }
    system "cmake", "--build", "_build"
    system "cmake", "--install", "_build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <string>
      #include <zug/transducer/filter.hpp>
      #include <zug/transducer/map.hpp>
      int main()
      {
      auto xf = zug::filter([](int x) { return x > 0; })
          | zug::map([](int x) { return std::to_string(x); });
      }
    CPP

    system ENV.cxx, "-std=c++17", "-I#{include}", "test.cpp", "-o", "test"
    system "./test"
  end
end
