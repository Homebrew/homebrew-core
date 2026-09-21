class RangeV3 < Formula
  desc "Experimental range library for C++14/17/20"
  homepage "https://ericniebler.github.io/range-v3/"
  url "https://github.com/ericniebler/range-v3/archive/refs/tags/0.12.0.tar.gz"
  sha256 "015adb2300a98edfceaf0725beec3337f542af4915cec4d0b89fa0886f4ba9cb"
  license "BSL-1.0"

  bottle do
    rebuild 3
    sha256 cellar: :any_skip_relocation, all: "6e8ed329dcadb543381b45e5fac6994216dd9240da78df421272e3a9672c5182"
  end

  depends_on "cmake" => :build

  # Drop the std forward declarations that clash with libc++ 22 (macOS 27 SDK)
  patch do
    url "https://github.com/ericniebler/range-v3/commit/54fca7092f21bb5f06bf25bc0d99a8f58142a14b.patch?full_index=1"
    sha256 "9fa907eaea528c547afd4643fa6e15131a6c827281b18628878794e9cc929414"
    type :unofficial
    resolves "https://github.com/ericniebler/range-v3/pull/1863"
  end

  def install
    args = %w[
      -DRANGE_V3_TESTS=OFF
      -DRANGE_V3_HEADER_CHECKS=OFF
      -DRANGE_V3_EXAMPLES=OFF
      -DRANGE_V3_PERF=OFF
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <range/v3/all.hpp>
      #include <iostream>
      #include <string>

      int main() {
        std::string s{ "hello" };
        ranges::for_each( s, [](char c){ std::cout << c << " "; });
        std::cout << std::endl;
      }
    CPP
    stdlib_ldflag = OS.mac? ? "-lc++" : "-lstdc++"
    flags = [stdlib_ldflag]
    flags << "-stdlib=libc++" if OS.mac?
    system ENV.cc, "test.cpp", "-std=c++14", *flags, "-o", "test"
    assert_equal "h e l l o \n", shell_output("./test")
  end
end
