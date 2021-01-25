class X264 < Formula
  desc "H.264/AVC encoder"
  homepage "https://www.videolan.org/developers/x264.html"
  license "GPL-2.0-only"
  revision 1
  head "https://code.videolan.org/videolan/x264.git"

  stable do
    # the latest commit on the stable branch
    url "https://code.videolan.org/videolan/x264.git",
        revision: "4121277b40a667665d4eea1726aefdc55d12d110"
    version "r3027"
  end

  # There's no guarantee that the versions we find on the `release-macos` index
  # page are stable but there didn't appear to be a different way of getting
  # the version information at the time of writing.
  livecheck do
    url "https://artifacts.videolan.org/x264/release-macos/"
    regex(%r{href=.*?x264[._-](r\d+)[._-][\da-z]+/?["' >]}i)
  end

  bottle do
    cellar :any
    sha256 "ae4f4d320db6d3c52c118da312de4118870c0d60228c085f87cf75b88b63c5fe" => :big_sur
    sha256 "7d52ee2a419ad50d0c1ba7fa5e8f7d85791a98319d891a5fd78c98be4cf72fe5" => :arm64_big_sur
    sha256 "60b2b82a877d14c5c02f28e0d51ae90b89d4a141fa3c4efcc3fed6926d41033a" => :catalina
    sha256 "25c5033625c3de8f4f2e4de5b9d2e3f954e42ec9ec04104f49d6d4c255f65286" => :mojave
    sha256 "7a7dbe31d8afd48909c01294cc165b60fcaa20ca3df245617151b13f38d7c626" => :high_sierra
  end

  depends_on "nasm" => :build

  if MacOS.version <= :high_sierra
    # Stack realignment requires newer Clang
    # https://code.videolan.org/videolan/x264/-/commit/b5bc5d69c580429ff716bafcd43655e855c31b02
    depends_on "gcc"
    fails_with :clang
  end

  def install
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
    assert_match version.to_s.delete("r"), shell_output("#{bin}/x264 --version").lines.first
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
