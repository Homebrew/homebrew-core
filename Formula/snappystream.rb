class Snappystream < Formula
  desc "C++ snappy stream realization (compatible with snappy)"
  homepage "https://github.com/hoxnox/snappystream"
  url "https://github.com/hoxnox/snappystream/archive/0.2.8.tar.gz"
  sha256 "53f15760eda2d19138a2e115850377ff4520e7009ff5501e2f175be45eb63614"
  head "https://github.com/hoxnox/snappystream.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "d0725f8e1b66534a5431abd46a999954a8ee51c4299096c5ec578d0d0a42a65c" => :high_sierra
    sha256 "2ddc050a7e877cf161303f8ced149e1f2cf12e927b67b7b60d58414afd26ff83" => :sierra
    sha256 "bfbec68310bb666e3601bb799a4bb2171eebc7da1441fbbeb419436dfb635fe0" => :el_capitan
    sha256 "dcfb20c5f44c386648367e7f376afa25511f352395371f5f7506bd65e6f382df" => :yosemite
  end

  depends_on "cmake" => :build
  depends_on "snappy"
  depends_on "boost" => :optional

  def install
    args = std_cmake_args + %w[. -DBUILD_TESTS=ON]
    args << "-DWITH_BOOST_IOSTREAMS=1" if build.with? "boost"
    system "cmake", *args
    system "make", "all", "test", "install"
  end

  test do
    (testpath/"testsnappystream.cxx").write <<~EOS
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
    system ENV.cxx, "testsnappystream.cxx", "-lsnappy", "-L#{lib}", "-lsnappystream", "-o", "testsnappystream"
    system "./testsnappystream < #{__FILE__} > out.dat && diff #{__FILE__} out.dat"
  end
end
