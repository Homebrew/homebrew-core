class Yazpp < Formula
  desc "C++ API for the Yaz toolkit"
  homepage "https://www.indexdata.com/resources/software/yazpp/"
  url "https://ftp.indexdata.com/pub/yazpp/yazpp-1.9.0.tar.gz"
  sha256 "17aa0f5b45edbfa9ee0363cb3b684e895d3d05e74024384d6c8707875621dcfc"
  license "BSD-3-Clause"

  livecheck do
    url "https://ftp.indexdata.com/pub/yazpp/"
    regex(/href=.*?yazpp[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "1282e706247f55d29fd6ae7db1132e0360339d64b7641d7a539cba08b6474532"
    sha256 cellar: :any,                 arm64_sequoia: "3db462397a75847cfe8f47b63a8e72357aeb56c3e6ad39f1e56f961fa6c67031"
    sha256 cellar: :any,                 arm64_sonoma:  "8a0413a93b0784924650e2e642e5044b3547361916ca81e4231828ce24ce3322"
    sha256 cellar: :any,                 arm64_ventura: "de090b1f94e5f04a32d266054df63e033d664af6baf02d70be02ee13ca2d2736"
    sha256 cellar: :any,                 sonoma:        "9a5bc3ac4c69833f33f9712a26d823c1f99348fec776a63eb04c1bf1b9cdc5d9"
    sha256 cellar: :any,                 ventura:       "41e4fc7540a5215ad4e4eff87779f604723adefc05223b4f16041fabdfe0723d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "90e01abea34f80017b98c621560c31326b42fc4abb0668b84e943117918e1ce6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fadea04212654ddcc34aa0a5bf5127f6c53a652c21d98a52b168c584e3a3fccc"
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
