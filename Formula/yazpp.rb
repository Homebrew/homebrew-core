class Yazpp < Formula
  desc "C++ API for the Yaz toolkit"
  homepage "https://www.indexdata.com/resources/software/yazpp/"
  url "https://ftp.indexdata.com/pub/yazpp/yazpp-1.8.0.tar.gz"
  sha256 "e6c32c90fa83241e44e506a720aff70460dfbd0a73252324b90b9489eaeb050d"
  license "BSD-3-Clause"
  revision 1

  livecheck do
    url "https://ftp.indexdata.com/pub/yazpp/"
    regex(/href=.*?yazpp[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "aa97daf6d2b5261aeac38b913d4987be6b3061cc2623f316f3dfc2290722c265"
    sha256 cellar: :any,                 arm64_big_sur:  "3fc6095e006360bca8b4c911c9b81b473c1da8c35f791c0c6a719aeba59d7323"
    sha256 cellar: :any,                 monterey:       "3c9e3071b8fd04b9aaf2bfbb0c535b7634aef29f613e45ec1c780f86cca0aa62"
    sha256 cellar: :any,                 big_sur:        "7d1a3021270686dc8164533c8dfc7d9d944bf4ba093b1f7f89087c9bf7c456e1"
    sha256 cellar: :any,                 catalina:       "2eaa4f5d58881c7ef007a18506bec5311044e958dd0ab37f1bf10984481faff3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a208d6ddfbf428b0f24a9afc17f8cdf6ac030c6390924c7b4f0c887fec541848"
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
