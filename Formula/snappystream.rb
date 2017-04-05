class Snappystream < Formula
  desc "C++ snappy stream realization (compatible with snappy)"
  homepage "https://github.com/hoxnox/snappystream"
  url "https://github.com/hoxnox/snappystream/archive/0.2.7.tar.gz"
  sha256 "be91c6bf304732b2d2d65c7ec57b8bf3daf1748c2ee932b852fd830db328ecc7"

  head "https://github.com/hoxnox/snappystream.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "ba3e2fb7979f1db9439b2e0bb5de7c9050d50d54b0e570048c89e23bd56e722a" => :sierra
    sha256 "6d09dd61cfc1c13c836b2937335dd0cec574c9d1a1936ed77481a774e7a106a3" => :el_capitan
    sha256 "f1a63095f32bba33e988ed760826f669fd2f1cba7fd58bdb9d0d77b823532b87" => :yosemite
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
    (testpath/"testsnappystream.cxx").write <<-EOS.undent
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
    system ENV.cxx, "testsnappystream.cxx", "-lsnappy", "-lsnappystream", "-o", "testsnappystream"
    system "./testsnappystream < #{__FILE__} > out.dat && diff #{__FILE__} out.dat"
  end
end
