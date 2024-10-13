class Wget2 < Formula
  desc "Successor of GNU Wget, a file and recursive website downloader"
  homepage "https://gitlab.com/gnuwget/wget2"
  url "https://ftp.gnu.org/gnu/wget/wget2-2.1.0.tar.gz"
  sha256 "a05dc5191c6bad9313fd6db2777a78f5527ba4774f665d5d69f5a7461b49e2e7"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
    regex(/href=.*?wget2[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 arm64_sequoia:  "6bc61f262e20d15cd1f079e71cd55e2a642fef0b66efbb77334773faef36aabe"
    sha256 arm64_sonoma:   "99ca029e3321591fa99a9af0e8b64f562dea3da226b823d35c5af55293b7a991"
    sha256 arm64_ventura:  "067870948de34bc06ebd36a69046d99fae639622d214272da2e3daac92f2f993"
    sha256 arm64_monterey: "923e704bf22d606bc90046a3b61e1ec65eee7e0ae557eb08ac3d6671849cf3e4"
    sha256 sonoma:         "41d146a9305abbf4a5e418e4a45f9a2aa6697a2490f528247cc359c8a0c9f9be"
    sha256 ventura:        "3f42f84bde572aa62f1c866d436f7a00760a3d7fae407a61c102b8087bd42696"
    sha256 monterey:       "28caefa64e171177a81c69c77d9252a312cc511028bde86702387f4d4d65a666"
    sha256 x86_64_linux:   "20df0cbf4bba791786a2e8c0be9ed8a448545e4cf68702a967fd76756c85b251"
  end

  depends_on "doxygen" => :build
  depends_on "graphviz" => :build
  depends_on "lzlib" => :build # static lib
  depends_on "pandoc" => :build
  depends_on "pkg-config" => :build
  depends_on "texinfo" => :build # Build fails with macOS-provided `texinfo`

  depends_on "brotli"
  depends_on "gnutls"
  depends_on "gpgme"
  depends_on "libidn2"
  depends_on "libnghttp2"
  depends_on "libpsl"
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
