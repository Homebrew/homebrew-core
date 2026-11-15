class Tabulate < Formula
  desc "Table Maker for Modern C++"
  homepage "https://github.com/p-ranav/tabulate"
  url "https://github.com/p-ranav/tabulate/archive/refs/tags/v2.2.tar.gz"
  sha256 "3c12853cbf103adf659c4821351a302351d139513f1c43528095da41e8a37044"
  license all_of: [
    "MIT",
    "BSL-1.0",      # {optional,string_view,variant}_lite.hpp
    "BSD-3-Clause", # termcolor.hpp
  ]

  bottle do
    sha256 cellar: :any_skip_relocation, all: "079837d4b81f9905891ee95cb53c95d74747f6a61d84677603782411826e9d58"
  end

  depends_on "cmake" => :build

  deny_network_access!

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
