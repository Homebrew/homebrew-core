class Unibilium < Formula
  desc "Very basic terminfo library"
  homepage "https://github.com/neovim/unibilium"
  url "https://github.com/neovim/unibilium/archive/v2.1.0.tar.gz"
  sha256 "05bf97e357615e218126f7ac086e7056a23dc013cfac71643b50a18ad390c7d4"
  license "LGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "4615fc8228f3975d90334bbc9892e7fc5a0114cce8b1e9b0445c1d42f3caa4d1"
    sha256 cellar: :any, big_sur:       "1ac932c37c4889fdf5382a66a5c909ece4d4c854835b24215c3c96653ebb914d"
    sha256 cellar: :any, catalina:      "62b5e586837c4390918437def45064ce86c7ac8b81f570ceb11f98aed2b563af"
    sha256 cellar: :any, mojave:        "3b3292fa69eac93918fee92ffdb3b06f98524cc1fa705964a10fef35be4314a2"
  end

  depends_on "libtool" => :build

  def install
    system "make"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <unibilium.h>
      #include <stdio.h>

      int main()
      {
        setvbuf(stdout, NULL, _IOLBF, 0);
        unibi_term *ut = unibi_dummy();
        unibi_destroy(ut);
        return 0;
      }
    EOS
    system ENV.cc, "-I#{include}", "test.c", "-L#{lib}", "-lunibilium", "-o", "test"
    system "./test"
  end
end
