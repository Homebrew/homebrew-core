class Rttr < Formula
  desc "C++ Reflection Library"
  homepage "https://www.rttr.org"
  url "https://github.com/rttrorg/rttr/archive/v0.9.6.tar.gz"
  sha256 "058554f8644450185fd881a6598f9dee7ef85785cbc2bb5a5526a43225aa313f"
  license "MIT"
  head "https://github.com/rttrorg/rttr.git"

  depends_on "cmake" => :build
  depends_on "doxygen" => :build

  def install
    args = std_cmake_args
    args << "-DBUILD_UNIT_TESTS=OFF"

    mkdir "build" do
      system "cmake", "..", *args
      system "make", "install"
    end
  end

  test do
    hello_world = "Hello World"
    (testpath/"test.cpp").write <<~EOS
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
    EOS
    system ENV.cxx, "-std=c++11", "test.cpp", "-L#{lib}", "-lrttr_core", "-o", "test"
    assert_match hello_world, shell_output("./test")
  end
end
