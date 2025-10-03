class Tabulate < Formula
  desc "Table Maker for Modern C++"
  homepage "https://github.com/p-ranav/tabulate"
  url "https://github.com/p-ranav/tabulate/archive/refs/tags/v1.5.tar.gz"
  sha256 "16b289f46306283544bb593f4601e80d6ea51248fde52e910cc569ef08eba3fb"
  license all_of: [
    "MIT",
    "BSL-1.0",      # {optional,string_view,variant}_lite.hpp
    "BSD-3-Clause", # termcolor.hpp
  ]

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, all: "636ac9d2ecadd40138dc030e967b464b296cba28f5eb180377c7e18d18778f97"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    # https://github.com/p-ranav/tabulate/blob/master/samples/shape.cpp
    (testpath/"test.cpp").write <<~CPP
      #include <tabulate/table.hpp>
      using namespace tabulate;
      using Row_t = Table::Row_t;

      void print_shape(Table &table) {
        auto shape = table.shape();
        std::cout << "Shape: (" << shape.first << ", " << shape.second << ")" << std::endl;
      }

      int main() {
        Table table;
        table.add_row(Row_t{"Command", "Description"});
        table.add_row(Row_t{"git status", "List all new or modified files"});
        table.add_row(Row_t{"git diff", "Show file differences that haven't been staged"});
        std::cout << table << std::endl;
        print_shape(table);
      }
    CPP
    system ENV.cxx, "-std=c++11", "test.cpp", "-o", "test"
    assert_match "Shape: (63, 7)", shell_output("./test")
  end
end
