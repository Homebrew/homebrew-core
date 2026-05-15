class Wget2 < Formula
  desc "Successor of GNU Wget, a file and recursive website downloader"
  homepage "https://gitlab.com/gnuwget/wget2"
  url "https://ftpmirror.gnu.org/gnu/wget/wget2-2.2.1.tar.gz"
  sha256 "d7544b13e37f18e601244fce5f5f40688ac1d6ab9541e0fbb01a32ee1fb447b4"
  license "GPL-3.0-or-later"
  revision 1

  livecheck do
    url :stable
    regex(/href=.*?wget2[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "a3c51bc9ea360f1fa2ff6c74bf64e4c24dae20246c067d859b53e157122d2100"
    sha256 arm64_sequoia: "9b0c5b44ec766dc77c208499f9a3fc1f8075800d68bb9525b0ec115fca50762a"
    sha256 arm64_sonoma:  "c7aecfdd669dd4af9d7beeecde030f326411c336b86f53cdbd1df9af91f814a5"
    sha256 sonoma:        "dceb188cd3051a042fc58d659c3e9682e6e35ba8e18d76e3701a38290b9be699"
    sha256 arm64_linux:   "0bf487f6da889fada7335ae1fd2361b537550bdff94d9fe0df654a467a809e45"
    sha256 x86_64_linux:  "a1d0fc8b30a6090f2d9aa27ff7ccd6e37c1c33dbf1c5699f19ab4f67de80d000"
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

  on_macos do
    depends_on "gnu-sed" => :build
    depends_on "gettext"
  end

  on_linux do
    depends_on "zlib-ng-compat"
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

    # Remove `wget2_noinstall` binary, which is only for testing
    # https://gitlab.com/gnuwget/wget2/-/work_items/565#note_699151912
    rm bin/"wget2_noinstall"
  end

  test do
    system bin/"wget2", "-O", File::NULL, "https://google.com"
  end
end
