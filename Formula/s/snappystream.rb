class Snappystream < Formula
  desc "C++ snappy stream realization (compatible with snappy)"
  homepage "https://github.com/hoxnox/snappystream"
  url "https://github.com/hoxnox/snappystream/archive/refs/tags/1.0.0.tar.gz"
  sha256 "a50a1765eac1999bf42d0afd46d8704e8c4040b6e6c05dcfdffae6dcd5c6c6b8"
  license "Apache-2.0"
  revision 1
  head "https://github.com/hoxnox/snappystream.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "1b9bfaec4d6e7207937aa78282ec7fd13860da55f88a518ad7c0804a4b6004fd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "8bfb07955fdb8b0896bbb1084651c320a78d2e5e4ae5d26242b86469ae8d39aa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4647e986c27d16e41d5636d0d14b096f09a69e446e6cebf2715e2de88c579527"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b3e452bf6ee2fb64d89388ac99d1786218bad625c6fc71f0cb4284f57bf150c7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9c92c2f15283870584d9fe49062734d66b6c1db1f10bf018249c3a7cd0f9110f"
    sha256 cellar: :any_skip_relocation, sonoma:         "6e0352aaa68c6373355d22f3aa92fb056077439b26869bd317076176aea7bcab"
    sha256 cellar: :any_skip_relocation, ventura:        "87329a4191cefc04c19ae16543101a5d94336812ede1047c34e52db7ff2a4006"
    sha256 cellar: :any_skip_relocation, monterey:       "0d58d7dd0573099e572969f5d38c821317171db8de851d0c5d7eb56d46ac54ad"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "0c192dcba364b122bbf8428185f24a1ee4e47f7a0dbdac8b3b4cf0edd467823f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5689e64e2ccf991d92a2adff2eef8b2ac32490467ce64bc09e93cee407b60d8a"
  end

  depends_on "cmake" => :build
  depends_on "snappy"

  def install
    args = %w[
      -DBUILD_TESTS=ON
      -DCMAKE_CXX_STANDARD=11
    ]
    # Workaround to build with CMake 4
    args << "-DCMAKE_POLICY_VERSION_MINIMUM=3.5"
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cxx").write <<~CPP
      #include <iostream>
      #include <fstream>
      #include <iterator>
      #include <algorithm>
      #include <snappystream.hpp>

      int main()
      {
        { std::ofstream ofile("snappy-file.dat");
          snappy::oSnappyStream osnstrm(ofile);
          std::cin >> std::noskipws;
          std::copy(std::istream_iterator<char>(std::cin), std::istream_iterator<char>(), std::ostream_iterator<char>(osnstrm));
        }
        { std::ifstream ifile("snappy-file.dat");
          snappy::iSnappyStream isnstrm(ifile);
          isnstrm >> std::noskipws;
          std::copy(std::istream_iterator<char>(isnstrm), std::istream_iterator<char>(), std::ostream_iterator<char>(std::cout));
        }
      }
    CPP
    system ENV.cxx, "test.cxx", "-o", "test",
                    "-L#{lib}", "-lsnappystream",
                    "-L#{Formula["snappy"].opt_lib}", "-lsnappy"
    system "./test < #{__FILE__} > out.dat && diff #{__FILE__} out.dat"
  end
end
