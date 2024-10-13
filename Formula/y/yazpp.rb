class Yazpp < Formula
  desc "C++ API for the Yaz toolkit"
  homepage "https://www.indexdata.com/resources/software/yazpp/"
  url "https://ftp.indexdata.com/pub/yazpp/yazpp-1.8.1.tar.gz"
  sha256 "13b7e61b2f20a57d0925bf6925c1d82e40a11092a8d1ab1d9d49dfd1863dbb05"
  license "BSD-3-Clause"

  livecheck do
    url "https://ftp.indexdata.com/pub/yazpp/"
    regex(/href=.*?yazpp[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "3eb4675650e06795a7621b5ff0c82ee35be02f68b88f7e4e1ee356d8241329ee"
    sha256 cellar: :any,                 arm64_sonoma:   "be00d05febf66d4595ffe681fe00d93ca6c5f107bb7171b097ce52d74aaf0809"
    sha256 cellar: :any,                 arm64_ventura:  "6e7458ff48b91fc278beb85d320d739425c6ba2077b15f951866e6ead6cc09ac"
    sha256 cellar: :any,                 arm64_monterey: "aa4653b1b4bac44bb483c8f05a31f91b92a4cfe7ff5d338f357b01dc30156c4f"
    sha256 cellar: :any,                 arm64_big_sur:  "ca058f59600e3f8931894e93a6aa901bffd86306e84f8cbabb971a3115210022"
    sha256 cellar: :any,                 sonoma:         "2fef1de6d47229987bd0e0c8ba0702357336fa05182c1c114997b048b9b5c192"
    sha256 cellar: :any,                 ventura:        "5968798b57294be416bb06594f46b73720d0f3406cff786c3eb2255ac175c367"
    sha256 cellar: :any,                 monterey:       "fa049b03743d65e259b3fa771bf3228432b1d0edac7313f33843cbfa64683e0f"
    sha256 cellar: :any,                 big_sur:        "8ace99b6b578b30de4fba470ec066283240faef60528a847d617c8c33bd1c405"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "674c51fc6edefe40af90e0fd8b2c7ad2546f5c9edee89b973967b713d9a0eee8"
  end

  depends_on "yaz"

  def install
    ENV.cxx11 if OS.linux? # due to `icu4c` dependency in `libxml2`
    system "./configure", *std_configure_args
    system "make", "install"

    # Replace `yaz` cellar paths, which break on `yaz` version or revision bumps
    inreplace bin/"yazpp-config", Formula["yaz"].prefix.realpath, Formula["yaz"].opt_prefix
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <iostream>
      #include <yazpp/zoom.h>

      using namespace ZOOM;

      int main(int argc, char **argv){
        try
        {
          connection conn("wrong-example.xyz", 210);
        }
        catch (exception &e)
        {
          std::cout << "Exception caught";
        }
        return 0;
      }
    EOS

    system ENV.cxx, "test.cpp", "-std=c++11", "-I#{include}/src",
                    "-L#{lib}", "-lzoompp", "-o", "test"
    output = shell_output("./test")
    assert_match "Exception caught", output
  end
end
