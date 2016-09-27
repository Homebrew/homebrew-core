class VorbisTools < Formula
  desc "Ogg Vorbis CODEC tools"
  homepage "http://vorbis.com"
  url "http://downloads.xiph.org/releases/vorbis/vorbis-tools-1.4.0.tar.gz"
  sha256 "a389395baa43f8e5a796c99daf62397e435a7e73531c9f44d9084055a05d22bc"
  revision 1

  bottle do
    sha256 "d98cd4b862786d666f031829fa72a367734ac0ec63c6477e80e16b575ead3b51" => :sierra
    sha256 "b95e6fb92f692cd321bc09952fc9d369533d847c320eac9f0172f0fce3f4beff" => :el_capitan
    sha256 "0619896b3b6b268bc1f8ac81b52b77011196a019134473f2b680e9c941214590" => :yosemite
    sha256 "4f4355cd1413f3aec51d51287fe4bedebd4571e1222f611421f5557edc411cab" => :mavericks
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
