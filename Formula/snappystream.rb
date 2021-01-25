class Snappystream < Formula
  desc "C++ snappy stream realization (compatible with snappy)"
  homepage "https://github.com/hoxnox/snappystream"
  url "https://github.com/hoxnox/snappystream/archive/1.0.0.tar.gz"
  sha256 "a50a1765eac1999bf42d0afd46d8704e8c4040b6e6c05dcfdffae6dcd5c6c6b8"
  license "Apache-2.0"
  head "https://github.com/hoxnox/snappystream.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "0259933ab01a0edf8162f901820728e9f36e0244e6dc34aa8de64caf95247bcb" => :big_sur
    sha256 "4723ca8cfbd115326740f631b84db163cba902c1233c98e0b413a4250c228692" => :arm64_big_sur
    sha256 "083a4297326a9171920d68c6f0d93891d1cef8971546efd0293360b8dfc4e564" => :catalina
    sha256 "f768ccd06fd8d1cceb9905d71d7be38b55c3d2797df8d58a4f5528f22144db6d" => :mojave
  end

  depends_on "cmake" => :build
  depends_on "snappy"

  def install
    system "cmake", ".", *std_cmake_args, "-DBUILD_TESTS=ON", "-DCMAKE_CXX_STANDARD=11"
    system "make", "all", "test", "install"
  end

  test do
    (testpath/"test.cxx").write <<~EOS
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
    EOS
    system ENV.cxx, "test.cxx", "-o", "test",
                    "-L#{Formula["snappy"].opt_lib}", "-lsnappy",
                    "-L#{lib}", "-lsnappystream"
    system "./test < #{__FILE__} > out.dat && diff #{__FILE__} out.dat"
  end
end
