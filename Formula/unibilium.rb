class Unibilium < Formula
  desc "Very basic terminfo library"
  homepage "https://github.com/mauke/unibilium"
  url "https://github.com/mauke/unibilium/archive/v2.0.0.tar.gz"
  sha256 "78997d38d4c8177c60d3d0c1aa8c53fd0806eb21825b7b335b1768d7116bc1c1"

  bottle do
    cellar :any
    sha256 "5c29d645cd3e0ad950a7054c73b89cb76114b369476eb8bca26587c38571861d" => :high_sierra
    sha256 "15338d452e5e09e7b8f3bedd6d557d735d06bfbc53204487d11b6c225a04ad71" => :sierra
    sha256 "d8caea872f5f8ed11503e46fc37f17fafbc8a4c64a5382e2bf9e6d84feda2f98" => :el_capitan
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
