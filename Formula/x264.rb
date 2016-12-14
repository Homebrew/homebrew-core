# x264: Build a bottle for Linuxbrew
class X264 < Formula
  desc "H.264/AVC encoder"
  homepage "https://www.videolan.org/developers/x264.html"
  # the latest commit on the stable branch
  url "https://git.videolan.org/git/x264.git", :revision => "4d5c8b01a48f72f9c40651e92c39294326a0863f"
  version "r2728"
  head "https://git.videolan.org/git/x264.git"

  bottle do
    cellar :any
    sha256 "454351400844abc9ef9dc75eda60613e3522089f395aa7d7239abb6d801455dc" => :sierra
    sha256 "00ddf0e14555830c2be93db080e51a18915ecd7afdf43de676b57945f199f9ae" => :el_capitan
    sha256 "02985537eae4685adc60829b04f180b5a6e23192bb1864d2086f3cd6a7895781" => :yosemite
  end

  devel do
    # the latest commit on the master branch
    url "https://git.videolan.org/git/x264.git", :revision => "b97ae0644f16bad2e2c9c9181264a946769a0aa0"
    version "r2744"
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
    system ENV.cc, "-L", lib, "test.c", "-o", "test", "-lx264"
    system "./test"
  end
end
