class VorbisTools < Formula
  desc "Ogg Vorbis CODEC tools"
  homepage "https://github.com/xiph/vorbis-tools"
  url "https://downloads.xiph.org/releases/vorbis/vorbis-tools-1.4.0.tar.gz"
  sha256 "a389395baa43f8e5a796c99daf62397e435a7e73531c9f44d9084055a05d22bc"
  revision 2

  bottle do
    sha256 "ebcf801412fdea4ebf8e3dc850317fe6c8f8c4d9eeb10e3ba9c09bff3300b5cb" => :mojave
    sha256 "fd042bd1be3987bfd945e4e681d246b179af2f67ec139c51d62ce7ab27ff0fdd" => :high_sierra
    sha256 "6f6d8a2ac7093b409aae173ac42877fd9b3360284c17eb8789923c36e88acf00" => :sierra
    sha256 "d5ef7448a1d2373a418c87dbd5a74975b0979c0c3c411e49414fe54869f31482" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "flac"
  depends_on "libao"
  depends_on "libogg"
  depends_on "libvorbis"

  def install
    # Fix `brew linkage --test` "Missing libraries: /usr/lib/libnetwork.dylib"
    # Prevent bogus linkage to the libnetwork.tbd in Xcode 7's SDK
    ENV.delete("SDKROOT") if MacOS.version == :yosemite

    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --disable-nls
      --prefix=#{prefix}
    ]

    system "./configure", *args
    system "make", "install"
  end

  test do
    system bin/"oggenc", test_fixtures("test.wav"), "-o", "test.ogg"
    assert_predicate testpath/"test.ogg", :exist?
    output = shell_output("#{bin}/ogginfo test.ogg")
    assert_match "20.625000 kb/s", output
  end
end
