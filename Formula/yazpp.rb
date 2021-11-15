class Yazpp < Formula
  desc "C++ API for the Yaz toolkit"
  homepage "https://www.indexdata.com/resources/software/yazpp/"
  url "https://ftp.indexdata.com/pub/yazpp/yazpp-1.8.0.tar.gz"
  sha256 "e6c32c90fa83241e44e506a720aff70460dfbd0a73252324b90b9489eaeb050d"
  license "BSD-3-Clause"

  livecheck do
    url "https://ftp.indexdata.com/pub/yazpp/"
    regex(/href=.*?yazpp[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_monterey: "577457aa710814861f42b783fcc32c4f51f2df56b0c0b2834ea7bea916a2556a"
    sha256 cellar: :any, arm64_big_sur:  "beb0688e992377551877a54479486d836833702ea540c6a7d8a60220409c046d"
    sha256 cellar: :any, monterey:       "239c72f8472b69f74c4016818000810833480ab03d710c4c788b514ec78a22c4"
    sha256 cellar: :any, big_sur:        "d4676891be7edf41fbcccc88888a18703861c9db257cf65e8ef1b0cb7662dc9f"
    sha256 cellar: :any, catalina:       "71a7193513c4928805d0d7a55e7e8892adb7779b11da5584b06fd7329640a8bb"
    sha256 cellar: :any, mojave:         "a578d82eb791139b8dd98093d7e150ebbe92565beec2fa8d218be39498ae0baf"
  end

  depends_on "yaz"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
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

    system ENV.cxx, "-std=c++11", "-I#{include}/src", "-L#{lib}",
           "-lzoompp", "test.cpp", "-o", "test"
    output = shell_output("./test")
    assert_match "Exception caught", output
  end
end
