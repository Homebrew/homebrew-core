class Zile < Formula
  desc "Text editor development kit"
  homepage "https://www.gnu.org/software/zile/"
  # Before bumping to a new version, check the NEWS file to make sure it is a
  # stable release: https://git.savannah.gnu.org/cgit/zile.git/plain/NEWS
  # For context, see: https://github.com/Homebrew/homebrew-core/issues/67379
  url "https://ftp.gnu.org/gnu/zile/zile-2.6.2.tar.gz"
  mirror "https://ftpmirror.gnu.org/zile/zile-2.6.2.tar.gz"
  sha256 "77eb7daff3c98bdc88daa1ac040dccca72b81dc32fc3166e079dd7a63e42c741"
  license "GPL-3.0-or-later"
  version_scheme 1

  bottle do
    sha256 arm64_ventura:  "1268429ea4818cca64c876e674d4995fc7d04712b7830c846d0132bc3fabf965"
    sha256 arm64_monterey: "2fbea44ef3130aff7733469b94bc24e75978bdb5cf8858e848a9bc23c1ddd97e"
    sha256 arm64_big_sur:  "2975be9af2cd9d330bcf85dc81f9f74b2f30d17972e987db3fd225212b0483ff"
    sha256 ventura:        "115e3fd1f729eaa56b32f2ca64b7d9c6835643692f6a8ed73940f9ff2b09e08c"
    sha256 monterey:       "dfa880a340b349ada0e41f391743c4a9ea15f012e89d29695ae3f2f8c6da24ef"
    sha256 big_sur:        "128190a766b6a418d57718f597e33502b381ee1441b01edb35396fc486196665"
    sha256 catalina:       "a57829f30757e2cd9092e0178505a8f6b6dce9f50f5b9fada78b0c1eb2cbd692"
    sha256 mojave:         "bfac60d46d213913b7bccc3d6cdf998f487d080fef4a46c5608d20ab09a8b988"
    sha256 x86_64_linux:   "d300cfd773adeb8071731a7cdc19a68be46732e17e95ffd6373844b8ae6c4e0d"
  end

  depends_on "help2man" => :build
  depends_on "pkg-config" => :build
  depends_on "bdw-gc"
  depends_on "glib"
  depends_on "libgee"

  uses_from_macos "ncurses"

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/zile --version")
  end
end
