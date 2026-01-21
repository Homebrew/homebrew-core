class T1lib < Formula
  desc "C library to generate/rasterize bitmaps from Type 1 fonts"
  homepage "https://www.t1lib.org/"
  url "https://www.ibiblio.org/pub/linux/libs/graphics/t1lib-5.1.2.tar.gz"
  mirror "https://fossies.org/linux/misc/old/t1lib-5.1.2.tar.gz"
  sha256 "821328b5054f7890a0d0cd2f52825270705df3641dbd476d58d17e56ed957b59"
  license "GPL-2.0-only"

  livecheck do
    url "https://www.ibiblio.org/pub/Linux/libs/graphics/"
    regex(/href=.*?t1lib[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 2
    sha256                               arm64_tahoe:    "8d2eebfeac867815095b36e655608d597e57085aaf03946b961fd50b551ba984"
    sha256                               arm64_sequoia:  "b13bdc384d062e0a30c75b4ec280865e39273acb787acf872d98a416a5b08ffd"
    sha256                               arm64_sonoma:   "549b1729a39ffb52fa0a6e733d43f73d371bcbaea936270c5ad22e421c923127"
    sha256                               arm64_ventura:  "4178a1b4a03a25c8216994221938a31ea77cf68bc4e80e61995d3375423d12f2"
    sha256                               arm64_monterey: "015a6d7c251045c97f334922342d56d1ba93a398f32ba4c0b32ce9ef494fa02a"
    sha256                               arm64_big_sur:  "e9a134358b78dfcbf7d13a6edc7de434eb72981c14ec81d461527b05f2e32b1d"
    sha256                               sonoma:         "aaa86e53a2f28e3edae8eaad292cbb7beddc1251160bc9d28b7d6ae09e4cae7e"
    sha256                               ventura:        "54dc8980970a69062fe9eb15c368ad93b5d589fbea5e14766d6c2d22103d3506"
    sha256                               monterey:       "3989c26968d5f2d39ee4f6677121b3bafc455f7780eeb1394250792535f2392e"
    sha256                               big_sur:        "297e202327e6968bb7bd6d6ebff52205128189fa91bfc37785d45b4df028d3b6"
    sha256                               catalina:       "9318f5f1fcb5b4f3b0b5ce67c0925964c95bf10b7f843c70e4f6ed2b5a734360"
    sha256                               arm64_linux:    "53645a5cb98164213a964a7f5f38412e4ce9290e83d6147cb5d2cdf676354869"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "51b691773063f4f7c0e6cbfa5be259516c77ad7b1c52bb189d045b8056216bf9"
  end

  def install
    # Workaround for newer Clang
    ENV.append_to_cflags "-Wno-implicit-int" if DevelopmentTools.clang_build_version >= 1403

    args = []
    # Help old config scripts identify arm64 linux
    args << "--build=aarch64-unknown-linux-gnu" if OS.linux? && Hardware::CPU.arm? && Hardware::CPU.is_64_bit?

    system "./configure", *args, *std_configure_args
    system "make", "without_doc"
    system "make", "install"
    share.install "Fonts" => "fonts"
  end

  test do
    # T1_SetString seems to fail on macOS with "(E) T1_SetString(): t1_abort: Reason: unable to fix subpath break?"
    # https://github.com/Homebrew/homebrew-core/pull/194149#issuecomment-2412940237
    (testpath/"test.c").write <<~C
      #include <stdio.h>
      #include <stdlib.h>
      #include <t1lib.h>

      int main( void)
      {
        int i;
        T1_SetBitmapPad(16);

        if ((T1_InitLib(NO_LOGFILE)==NULL)){
          fprintf(stderr, "Initialization of t1lib failed\\n");
          return EXIT_FAILURE;
        }

        for( i=0; i<T1_GetNoFonts(); i++){
          printf("FontID=%d, Font=%s\\n", i, T1_GetFontFilePath(i));
          printf("FontID=%d, Metrics=%s\\n", i, T1_GetAfmFilePath(i));
          // T1_DumpGlyph(T1_SetString( i, "Test", 0, 0, T1_KERNING, 25.0, NULL));
        }

        T1_CloseLib();
        return EXIT_SUCCESS;
      }
    C

    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lt1", "-o", "test"

    testpath.install_symlink Formula["t1lib"].opt_share/"fonts/afm/bchr.afm"
    testpath.install_symlink Formula["t1lib"].opt_share/"fonts/type1/bchr.pfb"
    (testpath/"FontDataBase").write "1\nbchr.afm\n"
    (testpath/"t1lib.config").write <<~EOS
      FONTDATABASE=./FontDataBase
      ENCODING=.
      AFM=.
      TYPE1=.
    EOS

    expected_output = <<~EOS
      FontID=0, Font=./bchr.pfb
      FontID=0, Metrics=./bchr.afm
    EOS

    with_env(T1LIB_CONFIG: testpath/"t1lib.config") do
      assert_equal expected_output, shell_output("./test")
    end
  end
end
