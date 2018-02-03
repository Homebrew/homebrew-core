class X264 < Formula
  desc "H.264/AVC encoder"
  homepage "https://www.videolan.org/developers/x264.html"
  # the latest commit on the stable branch
  url "https://git.videolan.org/git/x264.git",
      :revision => "e9a5903edf8ca59ef20e6f4894c196f135af735e"
  version "r2854"
  head "https://git.videolan.org/git/x264.git"

  bottle do
    cellar :any
    sha256 "1f75c3a57ca3e1b7b528c04725c7d5c32dc1f4b222a289702dd7c057db8e34a2" => :high_sierra
    sha256 "815cd74498e36ce6df804d22561d99e1ef0d4b5706f28e2850b2ea3f6c6df406" => :sierra
    sha256 "be983033e47329fe52c1a32b1fcdfac071c495b24f4662584ad6165a0d126f30" => :el_capitan
    sha256 "1a7be693b06e4219ef7721586fce481065433759d0dc9ee3b6caab2e776317c4" => :yosemite
  end

  option "with-10-bit", "Build a 10-bit x264 (default: 8-bit)"
  option "with-l-smash", "Build CLI with l-smash mp4 output"

  depends_on "nasm" => :build
  depends_on "l-smash" => :optional

  deprecated_option "10-bit" => "with-10-bit"

  def install
    args = %W[
      --prefix=#{prefix}
      --enable-shared
      --enable-static
      --enable-strip
    ]
    args << "--disable-lsmash" if build.without? "l-smash"
    args << "--bit-depth=10" if build.with? "10-bit"

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
