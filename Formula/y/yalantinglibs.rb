class Yalantinglibs < Formula
  desc "Collection of modern C++ libraries"
  homepage "https://alibaba.github.io/yalantinglibs/en/"
  url "https://github.com/alibaba/yalantinglibs/archive/refs/tags/lts2.0.0.tar.gz"
  sha256 "0252e3b6c8e5ba37d20b5bdbb885184b2dac178a334ed7b67a6fbbebd604395d"
  license "Apache-2.0"
  head "https://github.com/alibaba/yalantinglibs.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "349baa306bc487853d0d3f3ab5c66bcdcb027b4809fbf7c4ed7f1122b09e65a8"
  end

  depends_on "cmake" => :build
  depends_on "asio"
  depends_on "async_simple"
  depends_on "frozen"
  depends_on "iguana"

  def install
    args = %w[
      -DINSTALL_INDEPENDENT_STANDALONE=OFF
      -DINSTALL_INDEPENDENT_THIRDPARTY=OFF
      -DINSTALL_STANDALONE=OFF
      -DINSTALL_THIRDPARTY=OFF
    ]

    system "cmake", "-S", ".", "-B", "builddir", *args, *std_cmake_args
    system "cmake", "--build", "builddir"
    system "cmake", "--install", "builddir"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
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
      }
    CPP
    system ENV.cxx, "test.cpp", "-std=c++20", "-o", "test"
    system "./test"
  end
end
