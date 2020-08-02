class X264 < Formula
  desc "H.264/AVC encoder"
  homepage "https://www.videolan.org/developers/x264.html"
  license "GPL-2.0"
  head "https://code.videolan.org/videolan/x264.git"

  stable do
    # the latest commit on the stable branch
    url "https://code.videolan.org/videolan/x264.git",
        revision: "cde9a93319bea766a92e306d69059c76de970190"
    version "r3011"
  end

  bottle do
    cellar :any
    rebuild 1
    sha256 "ba7da48fdd2dc85d18cf8ab11563bc9bfc04493a65a9909c5f70c84433ce5a7c" => :catalina
    sha256 "309008e3a647544faf6fd640ab8d91a30082b1d100126b8afbea3912ba32ffa3" => :mojave
    sha256 "5e03addc818d8631053aea74bf121de8aa885991646082a1dd2dd0cc57b00ef3" => :high_sierra
  end

  depends_on "nasm" => :build

  if MacOS.version <= :high_sierra
    # Stack realignment requires newer Clang
    # https://code.videolan.org/videolan/x264/-/commit/b5bc5d69c580429ff716bafcd43655e855c31b02
    depends_on "gcc"
    fails_with :clang
  end

  # update config.* and configure: add Apple Silicon support.
  # upstream PR https://code.videolan.org/videolan/x264/-/merge_requests/35
  # Can be removed once it gets merged into stable branch
  patch do
    url "https://code.videolan.org/videolan/x264/-/commit/eb95c2965299ba5b8598e2388d71b02e23c9fba7.diff?full_index=1"
    sha256 "7cdc60cffa8f3004837ba0c63c8422fbadaf96ccedb41e505607ead2691d49b9"
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
