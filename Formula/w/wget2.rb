class Wget2 < Formula
  desc "Successor of GNU Wget, a file and recursive website downloader"
  homepage "https://gitlab.com/gnuwget/wget2"
  url "https://gitlab.com/gnuwget/wget2/uploads/83752270de83e103306576e67a1c7c80/wget2-2.0.1.tar.gz"
  sha256 "0bb7fa03697bb5b8d05e1b5e15b863440826eb845874c4ffb5e32330f9845db1"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_sonoma:   "b08443020816dc22cf93815c350b30f0861f005e23238c2d142db09dffebae25"
    sha256 arm64_ventura:  "fa4432f5f7ce4d83c9fe0a9e89b45f5c9f53c78915538081f8316232f16d363a"
    sha256 arm64_monterey: "1d39d7e9074e73dd041b3c87e7461c39a9a077239cd6209b2b5cfe6ccfdb1b6e"
    sha256 arm64_big_sur:  "11191e2efde22f9e98b6f3eb2e1640e720d795b0af23651d65ae4e542eb3a4f7"
    sha256 sonoma:         "e1465119d071bf1f21d8e0d25d6abb930e7d12a92901091ae1e59d0682a6f620"
    sha256 ventura:        "b0a0dd524e72ca51c58433fd4f5371b1c7b9ad42a00709a29e9a1c6232f2813a"
    sha256 monterey:       "e1e86a64b8229d64fc73a56cee68e281ea3f93465d1b22f2653704fed0e3f683"
    sha256 big_sur:        "95703ee9f7a7c55fd50b3fbe4e77321d1db04ff77dfbae5f080099fa54b672eb"
    sha256 x86_64_linux:   "7e240a02462644bc2da043b1c90332b62702115338b41eb55463b47620e3df4f"
  end

  depends_on "doxygen" => :build
  # The pattern used in 'docs/wget2_md2man.sh.in' doesn't work with system sed
  depends_on "gnu-sed" => :build
  depends_on "graphviz" => :build
  depends_on "lzip" => :build
  depends_on "pandoc" => :build
  depends_on "pkg-config" => :build
  depends_on "texinfo" => :build # Build fails with macOS-provided `texinfo`

  depends_on "brotli"
  depends_on "gettext"
  depends_on "gnutls"
  depends_on "gpgme"
  depends_on "libassuan"
  depends_on "libgpg-error"
  depends_on "libidn2"
  depends_on "libmicrohttpd"
  depends_on "libnghttp2"
  depends_on "libpsl"
  depends_on "libtasn1"
  depends_on "lzlib"
  depends_on "nettle"
  depends_on "p11-kit"
  depends_on "pcre2"
  depends_on "xz"
  depends_on "zstd"

  uses_from_macos "bzip2"
  uses_from_macos "icu4c"
  uses_from_macos "zlib"

  def install
    gnused = Formula["gnu-sed"]
    lzlib = Formula["lzlib"]
    gettext = Formula["gettext"]

    # The pattern used in 'docs/wget2_md2man.sh.in' doesn't work with system sed
    ENV.prepend_path "PATH", gnused.libexec/"gnubin"
    ENV.append "LZIP_CFLAGS", "-I#{lzlib.include}"
    ENV.append "LZIP_LIBS", "-L#{lzlib.lib} -llz"

    system "./configure", *std_configure_args,
           "--with-bzip2",
           "--with-lzma",
           "--with-libintl-prefix=#{gettext.prefix}"

    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/wget2 --version")
  end
end
