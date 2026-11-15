class Tclap < Formula
  desc "Templatized C++ command-line parser library"
  homepage "https://tclap.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/tclap/v1.6.0/tclap-1.6.0.tar.gz"
  sha256 "2ed4bb7655cb4feb7a0432311f1194875bf2d61d6624bf3e513fa101cb0bcb10"
  license "MIT"
  compatibility_version 1

  livecheck do
    url :stable
    regex(%r{url=.*?/tclap[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "8e5c1727caf71a057232bc1248acbedae6eac6b1fe752da419d533fafcf26d76"
  end

  depends_on "cmake" => :build

  def install
    args = %w[
      -DBUILD_EXAMPLES=OFF
      -DBUILD_DOC=OFF
    ]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    # Based on https://sourceforge.net/p/tclap/code/ci/1.4/tree/examples/test1.cpp
    (testpath/"test.cpp").write <<~CPP
      #include <string>
      #include <iostream>
      #include <algorithm>
      #include "tclap/CmdLine.h"

      using namespace TCLAP;
      using namespace std;

      int main(int argc, char** argv) {
        CmdLine cmd("Command description message", ' ', "0.9");
        ValueArg<string> nameArg("n", "name", "Name to print", true, "homer", "string");
        cmd.add(nameArg);
        SwitchArg reverseSwitch("r", "reverse", "Print name backwards", false);
        cmd.add(reverseSwitch);
        cmd.parse(argc, argv);
        string name = nameArg.getValue();
        bool reverseName = reverseSwitch.getValue();
        if (reverseName) {
          reverse(name.begin(), name.end());
        }
        cout << name;
      }
    CPP
    system ENV.cxx, "test.cpp", "-std=c++20", "-o", "test"
    assert_equal "werbemoH", shell_output("./test -r -n Homebrew")
  end
end
