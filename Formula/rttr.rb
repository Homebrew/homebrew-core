class Rttr < Formula
  desc "C++ Reflection Library"
  homepage "https://www.rttr.org"
  url "https://github.com/rttrorg/rttr/archive/v0.9.6.tar.gz"
  sha256 "058554f8644450185fd881a6598f9dee7ef85785cbc2bb5a5526a43225aa313f"
  license "MIT"
  head "https://github.com/rttrorg/rttr.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "4aeeb410f8918197af10c1f52ed56d98c7d150b6c08ea3da94b1ef176abfc75b"
    sha256 cellar: :any,                 arm64_big_sur:  "8064ec9a745621fcd2e913f48e188fbbdb01a870fe76ba3c66ebb88e20295556"
    sha256 cellar: :any,                 monterey:       "276fea35306e5bb1f9d56520a4cb1ebdc6cb99183abe7f40338c9eccf3c9f357"
    sha256 cellar: :any,                 big_sur:        "b1e8b3136ef06805c2e2f7638747e18f03fec35fd71ce2d0f12bb67a340ec635"
    sha256 cellar: :any,                 catalina:       "84e56a259db377594ffd19dbbcd8740f901a59a5c1e4dd112aba54600448d919"
    sha256 cellar: :any,                 mojave:         "1130d4fa5016ad615dabc2a88c40aee36d2476ce4fea850a40643b78d44843f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2773d72369cd12e7ab3c26af035f13a68e908fbd69a0faad42e54d3185d25097"
  end

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
