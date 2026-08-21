class Yalantinglibs < Formula
  desc "Collection of modern C++ libraries"
  homepage "https://alibaba.github.io/yalantinglibs/en/"
  url "https://github.com/alibaba/yalantinglibs/archive/refs/tags/0.6.1.tar.gz"
  sha256 "2ef2089a49a08f764c558e9caf46e1d37697b111e04a48e5c5156f57f3afff24"
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/alibaba/yalantinglibs.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "3a7c99cc93921b67d8b4ea20eda1da4b4e66624f6d0b1be00f407a44d1a0bcda"
  end

  depends_on "cmake" => :build
  depends_on "asio"
  depends_on "async_simple"
  depends_on "frozen"
  depends_on "iguana"

  # Bump `YLT_VERSION`, which upstream left at 0.6.0 in the 0.6.1 release
  patch do
    url "https://github.com/alibaba/yalantinglibs/commit/8779b22851f6f8a1919e3992cd286953ed724d8c.patch?full_index=1"
    sha256 "62ceff19d4ef81d92044f5c5ebdceb09d6d9e368b8d74c6fe3a9acd90e33da8a"
    type :backport
    resolves "https://github.com/alibaba/yalantinglibs/pull/1203"
  end

  def install
    args = %w[
      -DINSTALL_INDEPENDENT_STANDALONE=OFF
      -DINSTALL_INDEPENDENT_THIRDPARTY=OFF
      -DINSTALL_STANDALONE=OFF
      -DINSTALL_THIRDPARTY=OFF
      -DBUILD_EXAMPLES=OFF
      -DBUILD_UNIT_TESTS=OFF
      -DBUILD_BENCHMARK=OFF
    ]

    system "cmake", "-S", ".", "-B", "builddir", *args, *std_cmake_args
    system "cmake", "--build", "builddir"
    system "cmake", "--install", "builddir"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <iostream>
      #include "ylt/version.hpp"
      #include "ylt/struct_json/json_reader.h"
      #include "ylt/struct_json/json_writer.h"

      struct person {
       std::string name;
       int age;
      };
      YLT_REFL(person, name, age);

      int main() {
        person p{.name = "tom", .age = 20};
        std::string str;
        struct_json::to_json(p, str); // {"name":"tom","age":20}
        person p1;
        struct_json::from_json(p1, str);
        std::cout << YLT_VERSION / 100000 << "." << YLT_VERSION / 100 % 1000 << "." << YLT_VERSION % 100;
      }
    CPP

    system ENV.cxx, "test.cpp", "-std=c++20", "-o", "test"
    assert_equal version.to_s, shell_output("./test")
  end
end
