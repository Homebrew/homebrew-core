class Unibilium < Formula
  desc "Very basic terminfo library"
  homepage "https://github.com/mauke/unibilium"
  url "https://github.com/mauke/unibilium/archive/v2.0.0.tar.gz"
  sha256 "78997d38d4c8177c60d3d0c1aa8c53fd0806eb21825b7b335b1768d7116bc1c1"

  bottle do
    cellar :any
    sha256 "0eabdc993e3e9af53e634963ef18f3735216eaf6da7cb12802643f0b9fb3e7df" => :high_sierra
    sha256 "53b708223a2e95298390b6313ff4917f10efefc3cf349eb57688938f982ee487" => :sierra
    sha256 "5c4b97baf010a4d3482f7270e313a274a281df71beb55a8ce69b473611c955ae" => :el_capitan
    sha256 "a43da6e759273b81f501077deb01633b54591a907e2cef40ba81b1611af5692e" => :yosemite
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
