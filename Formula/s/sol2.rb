class Sol2 < Formula
  desc "C++ <-> Lua API wrapper with advanced features and top notch performance"
  homepage "https://sol2.readthedocs.io/en/latest/"
  url "https://github.com/ThePhD/sol2/archive/refs/tags/v3.5.0.tar.gz"
  sha256 "86c0f6d2836b184a250fc2907091c076bf53c9603dd291eaebade36cc342e13c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "0eb3e697a4eea493659041a9c714c3b7ba1dad59c38e10fbea596f2d4825a6b1"
  end

  depends_on "cmake" => :build
  depends_on "lua" => [:build, :test]
  depends_on "pkgconf" => :build

  # Add Lua 5.5 support
  # https://github.com/ThePhD/sol2/pull/1723
  patch do
    url "https://github.com/ThePhD/sol2/commit/16a9fabb7ae525d644d3343f15b1de39c8865ecd.patch?full_index=1"
    sha256 "dee0b86ef931000e93f9214e72a8d4803dcf7ffd43365ce07d40184586d10cea"
  end

  def install
    # Fix `usertype_container` compilation for associative containers.
    # https://github.com/ThePhD/sol2/pull/1676
    inreplace "include/sol/usertype_container.hpp", "auto& end = i.end();", "auto& end = i.sen();"

    system "cmake", "-S", ".", "-B", "build", "-DSOL2_BUILD_LUA=OFF", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <sol/sol.hpp>
      #include <cassert>

      int main() {
          sol::state lua;
          int x = 0;
          lua.set_function("beep", [&x]{ ++x; });
          lua.script("beep()");
          assert(x == 1);
      }
    CPP

    system ENV.cxx, "test.cpp", "-std=c++17", "-I#{include}",
                    "-L#{Formula["lua"].opt_lib}", "-llua", "-o", "test"
    system "./test"
  end
end
