class X264 < Formula
  desc "H.264/AVC encoder"
  homepage "https://www.videolan.org/developers/x264.html"
  head "https://git.videolan.org/git/x264.git"

  stable do
    # the latest commit on the stable branch
    url "https://git.videolan.org/git/x264.git",
        :revision => "0a84d986e7020f8344f00752e3600b9769cc1e85"
    version "r2917"
  end

  bottle do
    cellar :any
    rebuild 1
    sha256 "b6c3f76b92275b17f6ee61de360db9200112ac529d58ae36267b6c955fea4ac3" => :mojave
    sha256 "f9217e7b29e737cc050f04183266a19c75fb01b1e9101818bad014a7cdf62f16" => :high_sierra
    sha256 "c047a907ed59ffecfba24792f800c21a3226cadb6cb2155943711a373950a1eb" => :sierra
    sha256 "04a9a0a821da861a283c92993426c1cdfe3cfd786898b7dac8bd9c477c5d02d7" => :el_capitan
  end

  depends_on "nasm" => :build

  def install
    args = %W[
      --prefix=#{prefix}
      --disable-lsmash
      --enable-shared
      --enable-static
      --enable-strip
    ]

    system "./configure", *args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdint.h>
      #include <x264.h>

      int main()
      {
          x264_picture_t pic;
          x264_picture_init(&pic);
          x264_picture_alloc(&pic, 1, 1, 1);
          x264_picture_clean(&pic);
          return 0;
      }
    EOS
    system ENV.cc, "-L#{lib}", "-lx264", "test.c", "-o", "test"
    system "./test"
  end
end
