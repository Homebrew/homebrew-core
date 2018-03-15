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
    sha256 "2e2cf99b9f06181e9d1bbd549e3426717d4fb93fc12fe2cd7f295b92f7b28a55" => :high_sierra
    sha256 "b656ff61da5b8ab33dc940bb4efa57bed89c3d40e79416aee8a960d8f7f2e4f1" => :sierra
    sha256 "3ac151bdd5cf62a55fb41c60761c548db721a7b6c1ebc6f4af5b4fc71b499e7f" => :el_capitan
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
