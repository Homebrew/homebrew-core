class X264 < Formula
  desc "H.264/AVC encoder"
  homepage "https://www.videolan.org/developers/x264.html"
  # the latest commit on the stable branch
  url "https://git.videolan.org/git/x264.git", :revision => "97eaef2ab82a46d13ea5e00270712d6475fbe42b"
  version "r2748"
  revision 1
  head "https://git.videolan.org/git/x264.git"

  bottle do
    cellar :any
    sha256 "e7b49d928421526258edb4021324a9c5bc6c9823e25c4f06070ffb4dbf9ce3c5" => :sierra
    sha256 "59c336f951b9fc03a26574dc29da0ee6e6e45cbf4e3245de7529271c134f149c" => :el_capitan
    sha256 "92ba46544181c3f7039fb62e6dd6e730e214dece3a3866f2a3bb8eb824701cbf" => :yosemite
  end

  option "with-10-bit", "Build a 10-bit x264 (default: 8-bit)"
  option "with-l-smash", "Build CLI with l-smash mp4 output"

  depends_on "yasm" => :build
  depends_on "l-smash" => :optional

  deprecated_option "10-bit" => "with-10-bit"

  def install
    args = %W[
      --prefix=#{prefix}
      --enable-shared
      --enable-static
      --enable-strip
    ]
    args <<  "--extra-cflags=-framework OpenCL"
    args <<  "--extra-ldflags=-framework OpenCL"
    args << "--disable-lsmash" if build.without? "l-smash"
    args << "--bit-depth=10" if build.with? "10-bit"

    system "./configure", *args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
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
    system ENV.cc, "-lx264", "test.c", "-o", "test"
    system "./test"
  end
end
