class Yazpp < Formula
  desc "C++ API for the Yaz toolkit"
  homepage "https://www.indexdata.com/resources/software/yazpp/"
  url "https://ftp.indexdata.com/pub/yazpp/yazpp-1.9.2.tar.gz"
  sha256 "92516d1d889dd6ff617d92b3af0ba28861dbd1fc436cfcadd0fde65ca9f34fe9"
  license "BSD-3-Clause"

  livecheck do
    url "https://ftp.indexdata.com/pub/yazpp/"
    regex(/href=.*?yazpp[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "e8c2b70a18bbe278927fa06a069100b0340dfabfe590f10d08579736adaa2e3e"
    sha256 cellar: :any,                 arm64_sequoia: "281fafaad2b0f09ef41c9ce57858635b84aab0e944526998680d87bf1c92f631"
    sha256 cellar: :any,                 arm64_sonoma:  "3f20f879fb18ad2c7ce22675ab7d02e65105828865e3ecd8ff13b28bbe2f19e2"
    sha256 cellar: :any,                 sonoma:        "ea001141255c11f6fecaa9f3944343b32fe8f258e28de326125469ddbef27854"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e657f22fabc2f1c1ab9dce23ced9fb4de0ccd9b497e8949b6a22fccf26321fd3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cd4606ca4186394c36e38a8a4c45a7e32a83eca100988492a97f50c4747e7fb2"
  end

  depends_on "pkgconf" => :build
  depends_on "yaz"

  def install
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
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
    CPP

    system ENV.cxx, "test.cpp", "-std=c++11", "-I#{include}/src",
                    "-L#{lib}", "-lzoompp", "-o", "test"
    output = shell_output("./test")
    assert_match "Exception caught", output
  end
end
