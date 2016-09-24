class X264 < Formula
  desc "H.264/AVC encoder"
  homepage "https://www.videolan.org/developers/x264.html"
  # the latest commit on the stable branch
  url "https://git.videolan.org/git/x264.git", :revision => "a5e06b9a435852f0125de4ecb198ad47340483fa"
  version "r2699"
  head "https://git.videolan.org/git/x264.git"

  bottle do
    cellar :any
    sha256 "48bbe37f3d559cf62baa2da53c6beaf62dc586e425851c8f9325213a81653ebd" => :sierra
    sha256 "749cf0abb596388079ccfc482060b61d40b381234c3f55f70664a21b87750b7d" => :el_capitan
    sha256 "25ae640bda892a1da820d7f8ab195fc441f439fb78fe9015bdbfa3dbbf5ad1d9" => :yosemite
    sha256 "ad6ba164deab0b1bd7cd19677c83d994522228e262fe3026aca321540da49e5c" => :mavericks
  end

  devel do
    # the latest commit on the master branch
    url "https://git.videolan.org/git/x264.git", :revision => "3f5ed56d4105f68c01b86f94f41bb9bbefa3433b"
    version "r2705"
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
    system ENV.cc, "-lx264", "test.c", "-o", "test"
    system "./test"
  end
end
