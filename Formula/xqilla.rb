class Xqilla < Formula
  desc "XQuery and XPath 2 command-line interpreter"
  homepage "https://xqilla.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/xqilla/XQilla-2.3.4.tar.gz"
  sha256 "292631791631fe2e7eb9727377335063a48f12611d641d0296697e0c075902eb"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(%r{url=.*?/XQilla[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_monterey: "adc61de0a3a381d0ceab22a8449c209d06ded447a3e2750733f673cbbc14ca82"
    sha256 cellar: :any,                 arm64_big_sur:  "1b8493188f6fc779948193c1ae7cc803e85a4a18c32464c039448a27f830d9fe"
    sha256 cellar: :any,                 monterey:       "27ceea9b020373aa347f20b2f42682d13d2cf2a513df4330ce45239a74d4340c"
    sha256 cellar: :any,                 big_sur:        "ac66706739f52be905422e387435524387fdec6ca86243aad5b8be446182d59a"
    sha256 cellar: :any,                 catalina:       "3e01ca81220688c9680e3c23c0f7434f415e2b1e7b2e812f514a540eb51b50cd"
    sha256 cellar: :any,                 mojave:         "93ae09129c45ee7b1a4ecfe996c305791e06833c1e73b604b33282e5ea90248a"
    sha256 cellar: :any,                 high_sierra:    "38579e6ab1b6f6801ca5404cc79fcd972f395b9dd2e981672889b3eac5441c86"
    sha256 cellar: :any,                 sierra:         "0f1ef8f2aa1349b723062426a3e44fba2821bcf93316bacabf4c5e2948093bc4"
    sha256 cellar: :any,                 el_capitan:     "4326ec876d3e05647320c4ab55824c37531af997cc723f303fac4c4b40153753"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0e1dc55c71a2508b0ed3319c87a3297bc92aa29b93bc86851a96fc4b34f376a3"
  end

  depends_on "xerces-c"

  conflicts_with "zorba", because: "both supply `xqc.h`"

  def install
    ENV.cxx11

    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--with-xerces=#{HOMEBREW_PREFIX}",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <iostream>
      #include <xqilla/xqilla-simple.hpp>

      int main(int argc, char *argv[]) {
        XQilla xqilla;
        AutoDelete<XQQuery> query(xqilla.parse(X("1 to 100")));
        AutoDelete<DynamicContext> context(query->createDynamicContext());
        Result result = query->execute(context);
        Item::Ptr item;
        while(item == result->next(context)) {
          std::cout << UTF8(item->asString(context)) << std::endl;
        }
        return 0;
      }
    EOS
    system ENV.cxx, "-std=c++11", testpath/"test.cpp", "-o", testpath/"test",
                    "-I#{include}", "-I#{Formula["xerces-c"].opt_include}",
                    "-L#{lib}", "-lxqilla",
                    "-L#{Formula["xerces-c"].opt_lib}", "-lxerces-c"
    system testpath/"test"
  end
end
