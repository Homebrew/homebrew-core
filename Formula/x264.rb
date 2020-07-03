class X264 < Formula
  desc "H.264/AVC encoder"
  homepage "https://www.videolan.org/developers/x264.html"
  head "https://code.videolan.org/videolan/x264.git"

  stable do
    # the latest commit on the stable branch
    url "https://code.videolan.org/videolan/x264.git",
        :revision => "cde9a93319bea766a92e306d69059c76de970190"
    version "r3011"
  end

  bottle do
    cellar :any
    sha256 "d3920895314d81fee66e88c945eab141be275ad3e42fc3aaac8fefa6d956df73" => :catalina
    sha256 "9f836c748fb02ab8e318f56b9b57e773177875b3a41a9bac04a8bac41b989b1a" => :mojave
    sha256 "ae608ff3910063f0ed5ed5eaaf3f60f58a3502ea6bdfa002937a2d4284f585db" => :high_sierra
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
