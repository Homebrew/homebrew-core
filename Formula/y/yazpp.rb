class Yazpp < Formula
  desc "C++ API for the Yaz toolkit"
  homepage "https://www.indexdata.com/resources/software/yazpp/"
  url "https://ftp.indexdata.com/pub/yazpp/yazpp-1.9.1.tar.gz"
  sha256 "7fe5487d66fafdb0a3c2ceeec2b7ad27d8d8718c57f5d6d7a5598d724ccee5d2"
  license "BSD-3-Clause"

  livecheck do
    url "https://ftp.indexdata.com/pub/yazpp/"
    regex(/href=.*?yazpp[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "677c4daba736dcf25027fbf4f5959ee72362f7f5fe48dadcc486c7d825c9d370"
    sha256 cellar: :any,                 arm64_sequoia: "bc9fd6e68ba2530c7fb772b73ed7d02a7bc9e23f5f6ec7fc95cb65802aa85ba1"
    sha256 cellar: :any,                 arm64_sonoma:  "a23e37c0b8def3ccae0b1017b8ebc738d0b1c3ef62d328d2201fbc1b18ac4841"
    sha256 cellar: :any,                 sonoma:        "9de8a746324a0f109f6925a679ada8ce20d36e459354b135318a7486bda5e26d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ec4cb7a2b40cc13cb050563725363088cfa8f5865fa2823ecea89e4dcd1b96cf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4795313aadd5eb1836d8299386570dd872993f28226031de66d371de07ff3161"
  end

  depends_on "pkgconf" => :build
  depends_on "yaz"

  def install
    ENV.cxx11 if OS.linux? # due to `icu4c` dependency in `libxml2`
    system "./configure", *std_configure_args
    system "make", "install"

    # Replace `yaz` cellar paths, which break on `yaz` version or revision bumps
    inreplace bin/"yazpp-config", Formula["yaz"].prefix.realpath, Formula["yaz"].opt_prefix
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
