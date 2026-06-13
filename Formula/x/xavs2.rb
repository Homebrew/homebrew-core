class Xavs2 < Formula
  desc "Encoder of AVS2-P2/IEEE1857.4 video coding standard"
  homepage "https://github.com/pkuvcl/xavs2"
  url "https://github.com/pkuvcl/xavs2/archive/refs/tags/1.4.tar.gz"
  mirror "https://gitee.com/pkuvcl/xavs2"
  sha256 "1e6d731cd64cb2a8940a0a3fd24f9c2ac3bb39357d802432a47bc20bad52c6ce"
  license "GPL-2.0-only"
  head "https://github.com/pkuvcl/xavs2.git", branch: "master"

  depends_on "avisynthplus" => :build
  depends_on "ffms2" => :build
  depends_on "gpac" => :build
  depends_on "ffmpeg"

  on_intel do
    depends_on "nasm" => :build
  end

  def install
    ENV["CFLAGS"] = "-Wno-incompatible-pointer-types" # Fix build with GCC 14.
    ENV["ASFLAGS"] = "-Wno-pp-macro-params-legacy" # Remove repeated warnings from nasm.
    host_arch = "#{Hardware::CPU.arm? ? "aarch64" : "x86_64"}-#{OS.mac? ? "apple-darwin" : "linux-gnu"}"
    args = %w[
      --enable-shared
    ]
    args << "--disable-asm" if Hardware::CPU.arm?

    # Fix GPAC detection
    inreplace "build/linux/configure", "gf_isom_set_pixel_aspect_ratio(0,0,0,0,0);",
                                       "gf_isom_set_pixel_aspect_ratio(0,0,0,0,0,GF_FALSE);"
    inreplace "build/linux/configure", 'GPAC_LIBS="-lgpac_static"', <<~EOS
      if $PKGCONFIG --exists gpac 2>/dev/null; then
          GPAC_LIBS="$GPAC_LIBS $($PKGCONFIG --static --libs gpac)"
          GPAC_CFLAGS="$GPAC_CFLAGS $($PKGCONFIG --cflags gpac)"
      fi
    EOS
    # Enable some features
    inreplace "build/linux/configure" do |s|
      s.gsub!('swscale="no"', 'swscale="auto"')
      s.gsub!('ffms="no"',    'ffms="yes"')
      s.gsub!('lavf="no"',    'lavf="yes"')
      s.gsub!('avs="no"',     'avs="yes"')
      s.gsub!('asm="no"',     'asm="auto"') unless Hardware::CPU.arm?
    end

    cd "build/linux" do
      system "./configure", "--host=#{host_arch}", "--prefix=#{prefix}", *args
      system "make"
      system "make", "install"
    end
  end

  test do
    system "ffmpeg", "-f", "lavfi", "-i", "testsrc=size=128x128:rate=25",
       "-pix_fmt", "yuv420p",
       "-t", "5",
       "test.yuv"
    system bin/"xavs2", "--Input=test.yuv", "--output=test.avs2"
  end
end
