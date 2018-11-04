class Snappystream < Formula
  desc "C++ snappy stream realization (compatible with snappy)"
  homepage "https://github.com/hoxnox/snappystream"
  url "https://github.com/hoxnox/snappystream/archive/1.0.0.tar.gz"
  sha256 "a50a1765eac1999bf42d0afd46d8704e8c4040b6e6c05dcfdffae6dcd5c6c6b8"
  head "https://github.com/hoxnox/snappystream.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "906ed99a4707b0b8a0fb1b14859b16bbdb23e61c4a1c3016559e4fb05398c118" => :mojave
    sha256 "93bfef130708be8e52485c4beea0524bbc89cbc2a076d2d456b10dd3d401136f" => :high_sierra
    sha256 "43253ef9ad617662532e7da29acf8721552a69733367043fa79c534db3ec5417" => :sierra
    sha256 "a43cdc3438c25363ee6d98c85bce3a777c07860265a5a120789eff46da1c71ec" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "snappy"

  def install
    system "cmake", ".", *std_cmake_args, "-DBUILD_TESTS=ON"
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
