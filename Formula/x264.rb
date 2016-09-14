class X264 < Formula
  desc "H.264/AVC encoder"
  homepage "https://www.videolan.org/developers/x264.html"
  # the latest commit on the stable branch
  url "https://git.videolan.org/git/x264.git", :revision => "fd2c324731c2199e502ded9eff723d29c6eafe0b"
  version "r2668"

  head "https://git.videolan.org/git/x264.git"

  bottle do
    cellar :any
    sha256 "5120b2c5e51669a0eae052f7fdc0af4519eaef4575349fb10824ac2ba9526f0e" => :sierra
    sha256 "8dd89dfa62eb8837f1a49450e7f6069502f49426ec4ea79357e980f534ea3e7a" => :el_capitan
    sha256 "edc6732b61f996968cc07c591cb17a5b4358a0db400c69e881c0559f6cf41ef8" => :yosemite
    sha256 "a64a08088aef050f6fc27f97a5bb411c9d75d94c0b9c1f0c8dfd99cdb7f1f4c9" => :mavericks
  end

  devel do
    # the latest commit on the master branch
    url "https://git.videolan.org/git/x264.git", :revision => "3b70645597bea052d2398005bc723212aeea6875"
    version "r2694"
  end

  option "with-10-bit", "Build a 10-bit x264 (default: 8-bit)"
  option "with-mp4=", "Select mp4 output: none (default), l-smash or gpac"

  depends_on "yasm" => :build

  deprecated_option "10-bit" => "with-10-bit"

  case ARGV.value "with-mp4"
  when "l-smash" then depends_on "l-smash"
  when "gpac" then depends_on "gpac"
  end

  def install
    args = %W[
      --prefix=#{prefix}
      --enable-shared
      --enable-static
      --enable-strip
    ]
    if Formula["l-smash"].installed?
      args << "--disable-gpac"
    elsif Formula["gpac"].installed?
      args << "--disable-lsmash"
    end
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
