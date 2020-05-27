class X264 < Formula
  desc "H.264/AVC encoder"
  homepage "https://www.videolan.org/developers/x264.html"
  head "https://code.videolan.org/videolan/x264.git"

  stable do
    # the latest commit on the stable branch
    url "https://code.videolan.org/videolan/x264.git",
        :revision => "296494a4011f58f32adc54304a2654627558c59a"
    version "r2999"
  end

  bottle do
    cellar :any
    sha256 "3471d2725e761ac6dbf3882b95c933e51ab70ca457975652d737f689a4ec529f" => :catalina
    sha256 "8fbd7a7f33e32af373555483d12a19658d5b0e712e95d7b874e40ca386aa06f9" => :mojave
    sha256 "d06faa65365f712fcaee10dd672280388a0219159f8175b31a226043a9a45cc8" => :high_sierra
  end

  depends_on "nasm" => :build

  if MacOS.version <= :high_sierra
    # Stack realignment requires newer Clang
    # https://code.videolan.org/videolan/x264/-/commit/b5bc5d69c580429ff716bafcd43655e855c31b02
    depends_on "gcc"
    fails_with :clang
  end

  def install
    # Work around Xcode 11 clang bug
    # https://bitbucket.org/multicoreware/x265/issues/514/wrong-code-generated-on-macos-1015
    ENV.append_to_cflags "-fno-stack-check" if DevelopmentTools.clang_build_version >= 1010

    args = %W[
      --prefix=#{prefix}
      --disable-lsmash
      --disable-swscale
      --disable-ffms
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
