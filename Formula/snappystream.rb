class Snappystream < Formula
  desc "C++ snappy stream realization (compatible with snappy)"
  homepage "https://github.com/hoxnox/snappystream"
  url "https://github.com/hoxnox/snappystream/archive/1.0.0.tar.gz"
  sha256 "a50a1765eac1999bf42d0afd46d8704e8c4040b6e6c05dcfdffae6dcd5c6c6b8"
  license "Apache-2.0"
  head "https://github.com/hoxnox/snappystream.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4f0621fed569c3f1f467fb5b89a1727d02dd9f069eac22dd662750764a34ad40"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4723ca8cfbd115326740f631b84db163cba902c1233c98e0b413a4250c228692"
    sha256 cellar: :any_skip_relocation, monterey:       "1c5ef41496ec66bddc4e850801c848886a096637917b178b5486f7b04e246fe3"
    sha256 cellar: :any_skip_relocation, big_sur:        "0259933ab01a0edf8162f901820728e9f36e0244e6dc34aa8de64caf95247bcb"
    sha256 cellar: :any_skip_relocation, catalina:       "083a4297326a9171920d68c6f0d93891d1cef8971546efd0293360b8dfc4e564"
    sha256 cellar: :any_skip_relocation, mojave:         "f768ccd06fd8d1cceb9905d71d7be38b55c3d2797df8d58a4f5528f22144db6d"
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
