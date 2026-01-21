class Wget2 < Formula
  desc "Successor of GNU Wget, a file and recursive website downloader"
  homepage "https://gitlab.com/gnuwget/wget2"
  url "https://ftpmirror.gnu.org/gnu/wget/wget2-2.2.1.tar.gz"
  sha256 "d7544b13e37f18e601244fce5f5f40688ac1d6ab9541e0fbb01a32ee1fb447b4"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
    regex(/href=.*?wget2[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "f3a9adec245bbd9635183135de06592de77d3adcc2399fc183223158cb87ee09"
    sha256 arm64_sequoia: "ad8b8ac220a86f7fdaf8e4ad4489cded0339c37d3ae28b10fa5ecf03719a0d33"
    sha256 arm64_sonoma:  "60b93781fbdb1aa2fe674b9367dfb744dee46574e86e570ca7b7af1cc0a28a00"
    sha256 sonoma:        "9dbb77158a907ea8a23e6f787ac84bfd5d7ef4f6ee820b3cc5f7a72c3dbbb02e"
    sha256 arm64_linux:   "f8bcd1f6bf5c56bb03b743083a814f77cf7d6bd4959311b5e9f8fcd71cd01f23"
    sha256 x86_64_linux:  "2f92b4c85c3a7e3676cff954aefd305b31fe259331c07085daa3cb486e4ee7e5"
  end

  depends_on "doxygen" => :build
  depends_on "graphviz" => :build
  depends_on "pandoc" => :build
  depends_on "pkgconf" => :build
  depends_on "texinfo" => :build # Build fails with macOS-provided `texinfo`

  depends_on "brotli"
  depends_on "gnutls"
  depends_on "gpgme"
  depends_on "libidn2"
  depends_on "libnghttp2"
  depends_on "libpsl"
  depends_on "lzlib" # static lib
  depends_on "pcre2"
  depends_on "xz"
  depends_on "zstd"

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  on_macos do
    depends_on "gnu-sed" => :build
    depends_on "gettext"
  end

  def install
    # The pattern used in 'docs/wget2_md2man.sh.in' doesn't work with system sed
    ENV.prepend_path "PATH", Formula["gnu-sed"].libexec/"gnubin" if OS.mac?

    lzlib = Formula["lzlib"]
    ENV.append "LZIP_CFLAGS", "-I#{lzlib.include}"
    ENV.append "LZIP_LIBS", "-L#{lzlib.lib} -llz"

    args = %w[
      --disable-silent-rules
      --with-bzip2
      --with-lzma
    ]
    args << "--with-libintl-prefix=#{Formula["gettext"].prefix}" if OS.mac?

    system "./configure", *args, *std_configure_args
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/wget2 --version")
  end
end
