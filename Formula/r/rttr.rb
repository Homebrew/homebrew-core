class Rttr < Formula
  desc "C++ Reflection Library"
  homepage "https://www.rttr.org"
  url "https://github.com/rttrorg/rttr/releases/download/v0.9.6/rttr-0.9.6-src.zip"
  sha256 "d6853be1bfc38da6fb4512ae4c0a116662f86fa81a6b2aab1c4dada2c16f375f"
  license "MIT"
  head "https://github.com/rttrorg/rttr.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_tahoe:   "7fea9cfe909f2c178adda52aa0ad4d6bcabd86fc59143a6bf529f3012dce1661"
    sha256 cellar: :any, arm64_sequoia: "e0ccf9ad193022b31554136cd5b6000bea3de91a2773bd252921a6b9d1c829c0"
    sha256 cellar: :any, arm64_sonoma:  "fa9c86b1ab2b643f7ee8c827e369ded119d210fff3a14fa9e5bdeb7dc22e0357"
    sha256 cellar: :any, sonoma:        "5649dfbcc6bc5fed517f407f32bf7e013afd3204ba476be021e629f1d4827997"
    sha256 cellar: :any, arm64_linux:   "fe4dafc0187aa65ff41620af4852f3f221f78a8de85679736f779154631dc7c5"
    sha256 cellar: :any, x86_64_linux:  "b61af2cbe570a6bbed52ce7a740737237243eeaa1347e4dfc9aa571d472474cd"
  end

  depends_on "cmake" => :build

  def install
    args = %w[
      -DBUILD_DOCUMENTATION=OFF
      -DBUILD_UNIT_TESTS=OFF
      -DCMAKE_CXX_FLAGS=-Wno-deprecated-declarations
    ]

    # Workaround to build with CMake 4
    args << "-DCMAKE_POLICY_VERSION_MINIMUM=3.5"

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    hello_world = "Hello World"
    (testpath/"test.cpp").write <<~CPP
      #include <iostream>
      #include <rttr/registration>

      static void f() { std::cout << "#{hello_world}" << std::endl; }
      using namespace rttr;
      RTTR_REGISTRATION
      {
          using namespace rttr;
          registration::method("f", &f);
      }
      int main()
      {
          type::invoke("f", {});
      }
      // outputs: "Hello World"
    CPP
    system ENV.cxx, "-std=c++11", "test.cpp", "-L#{lib}", "-lrttr_core", "-o", "test"
    assert_match hello_world, shell_output("./test")
  end
end
