class VorbisTools < Formula
  desc "Ogg Vorbis CODEC tools"
  homepage "http://vorbis.com"
  url "http://downloads.xiph.org/releases/vorbis/vorbis-tools-1.4.0.tar.gz"
  sha256 "a389395baa43f8e5a796c99daf62397e435a7e73531c9f44d9084055a05d22bc"
  revision 1

  bottle do
    revision 1
    sha256 "cd7429731b7a36e3f866b6614768b481b0ef2273abb90a0e1d4e1a951ec06dca" => :el_capitan
    sha256 "1e2a1fad6865b1c6e801e194f0613c5388cc8a59f6a1ef911cd7fbc9adbe45a1" => :yosemite
    sha256 "9f91df46cb24feb17968dea9619f2c059a581a0fafa106b774892aad95a9516a" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "libogg"
  depends_on "libvorbis"
  depends_on "libao"
  depends_on "flac" => :optional

  def install
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --disable-nls
      --prefix=#{prefix}
    ]

    args << "--without-flac" if build.without? "flac"

    system "./configure", *args
    system "make", "install"
  end

  test do
    system bin/"oggenc", test_fixtures("test.wav"), "-o", "test.ogg"
    assert File.exist?("test.ogg")
    output = shell_output("#{bin}/ogginfo test.ogg")
    assert_match "20.625000 kb/s", output
  end
end
