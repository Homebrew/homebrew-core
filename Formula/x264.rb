class X264 < Formula
  desc "H.264/AVC encoder"
  homepage "https://www.videolan.org/developers/x264.html"
  # the latest commit on the stable branch
  url "https://git.videolan.org/git/x264.git", :revision => "86b71982e131eaa70125f8d0e725fcade9c4c677"
  version "r2708"
  head "https://git.videolan.org/git/x264.git"

  bottle do
    cellar :any
    sha256 "a795934302fb05c99877f3964fda26c5eab209151f07fe71db9f2240af2ece32" => :sierra
    sha256 "996b9403ec3fd21d483b83a092433529f986838b1af3c010888ce2f4c5bb1f94" => :el_capitan
    sha256 "b9271495a8f01a534b123e1cc3061480ac9c5125489d701248b964ce5614da0a" => :yosemite
  end

  devel do
    # the latest commit on the master branch
    url "https://git.videolan.org/git/x264.git", :revision => "72d53ab2ac7af24597a824e868f2ef363a22f5d4"
    version "r2721"
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
