class Xavs < Formula
  desc "AVS1 encoder and decoder"
  homepage "https://www.avs.org.cn"
  url "https://svn.code.sf.net/p/xavs/code/trunk", revision: 55
  version "0.1.55"
  license "LGPL-2.0-or-later"
  head "https://svn.code.sf.net/p/xavs/code/trunk"

  livecheck do
    skip "Formula uses an unstable trunk version"
  end

  depends_on "ffmpeg" => :test

  def install
    # Don't try to use -soname on macOS
    inreplace "Makefile", "-Wl,-soname,", "" if OS.mac?

    system "./configure", "--disable-silent-rules",
                          "--enable-shared",
                          "--enable-pic",
                          "--disable-asm",
                          *std_configure_args
    system "make", "install"
  end

  test do
    ffmpeg = formula_opt_bin("ffmpeg")/"ffmpeg"
    png = test_fixtures("test.png")
    system ffmpeg.to_s, "-loop", "1", "-i", png.to_s, "-c:v", "libx264", "-t", "30",
                        "-pix_fmt", "yuv420p", "v.yuv"
    system bin/"xavs", "v.yuv", "-o", "v.avs", "1280x720", "--fps", "30"

    assert_path_exists testpath/"v.avs"
  end
end
