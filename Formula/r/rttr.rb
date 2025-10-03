class Rttr < Formula
  desc "C++ Reflection Library"
  homepage "https://www.rttr.org"
  url "https://github.com/rttrorg/rttr/archive/refs/tags/v0.9.6.tar.gz"
  sha256 "058554f8644450185fd881a6598f9dee7ef85785cbc2bb5a5526a43225aa313f"
  license "MIT"
  head "https://github.com/rttrorg/rttr.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "b7fbefc620c98f69bcb1b28040e8e12b972b59a462d6e0155eab4f9d962fe156"
    sha256 cellar: :any,                 arm64_sequoia:  "fb6ba7f707377b4817a16a4e9afa427d8e4117d8ea02b82d8af5e198c04cd6f6"
    sha256 cellar: :any,                 arm64_sonoma:   "e82299210a49d335b1563afe4dc0abaa3bcf1b6aeab8876f1904e9015b6cc101"
    sha256 cellar: :any,                 arm64_ventura:  "fa3316e83f1ef591accfaf47c509009633178b817e6a6d064c293faa53445bf0"
    sha256 cellar: :any,                 arm64_monterey: "4aeeb410f8918197af10c1f52ed56d98c7d150b6c08ea3da94b1ef176abfc75b"
    sha256 cellar: :any,                 arm64_big_sur:  "8064ec9a745621fcd2e913f48e188fbbdb01a870fe76ba3c66ebb88e20295556"
    sha256 cellar: :any,                 sonoma:         "79a60c3feaa552808753851ac7a5ee7c48d62160b17e3133d9ceea36a0288769"
    sha256 cellar: :any,                 ventura:        "8572bb48a52460b98f4292e253b0f441fe6036d766b1e6272fd891bdc7da159f"
    sha256 cellar: :any,                 monterey:       "276fea35306e5bb1f9d56520a4cb1ebdc6cb99183abe7f40338c9eccf3c9f357"
    sha256 cellar: :any,                 big_sur:        "b1e8b3136ef06805c2e2f7638747e18f03fec35fd71ce2d0f12bb67a340ec635"
    sha256 cellar: :any,                 catalina:       "84e56a259db377594ffd19dbbcd8740f901a59a5c1e4dd112aba54600448d919"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "c467dad3aa2b7d571f87ce82afa6e62afcfb128b4fefeb8a1a4e0914b0def40d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2773d72369cd12e7ab3c26af035f13a68e908fbd69a0faad42e54d3185d25097"
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build

  def install
    args = %w[
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
