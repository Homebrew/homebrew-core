class Xboard < Formula
  desc "Graphical user interface for chess"
  homepage "https://www.gnu.org/software/xboard/"
  url "https://ftpmirror.gnu.org/gnu/xboard/xboard-4.9.1.tar.gz"
  mirror "https://ftp.gnu.org/gnu/xboard/xboard-4.9.1.tar.gz"
  sha256 "2b2e53e8428ad9b6e8dc8a55b3a5183381911a4dae2c0072fa96296bbb1970d6"
  license "GPL-3.0-or-later"
  revision 4

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 arm64_tahoe:    "49fb2045c979c8788ec25bbba4416f8f5a38729d9018d610ea1dd41f2595263b"
    sha256 arm64_sequoia:  "a3b2d95bd28d0e7034e8c740bb5daf60ebd131dec5586eda4c8caa491b96f99b"
    sha256 arm64_sonoma:   "286ed707d8d03708c836b4ac6a00777425e5984b6fe5be083ae571cfcfccb877"
    sha256 arm64_ventura:  "50cd0e9fe8b8c1e1cafca11ab050238c046b037db55561204c25bd238438cdd4"
    sha256 arm64_monterey: "90dd23652bb03fee8b0ff31fba73ad979861fcefc17602a19d9197d0eee77170"
    sha256 sonoma:         "e03a15e4427bb343a6f1bdfbae67eb899542e0b9b78bb9bd70c8b3fe8efa1bee"
    sha256 ventura:        "144abeb78c31d18571fe410dbb0759657566bb9162013102bdb5c59fb95e1aae"
    sha256 monterey:       "983ceebe82b7abeb9c0126c06e9d8954302431c2de2f47e3a05b40423633be98"
    sha256 arm64_linux:    "a3c183cb0e434de3eec05adddb804c87f92d93c892d908cfcbd47d25a92ecfea"
    sha256 x86_64_linux:   "fa58bc09398cf9c5fcfe470ee69366d7d2e07b8e369475f54ca6d0c7426281fb"
  end

  head do
    url "https://git.savannah.gnu.org/git/xboard.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "gettext" => :build
  end

  depends_on "pkgconf" => :build
  depends_on "cairo"
  depends_on "fairymax"
  depends_on "gdk-pixbuf"
  depends_on "glib"
  depends_on "gtk+"
  depends_on "librsvg"
  depends_on "pango"
  depends_on "polyglot"

  on_macos do
    depends_on "at-spi2-core"
    depends_on "gettext"
    depends_on "harfbuzz"
  end

  on_system :linux, macos: :ventura_or_newer do
    depends_on "texinfo" => :build
  end

  def install
    ENV.append_to_cflags "-fcommon" if OS.linux?

    system "./autogen.sh" if build.head?
    system "./configure", "--disable-silent-rules",
                          "--disable-zippy",
                          "--with-gtk",
                          "--without-Xaw",
                          *std_configure_args
    system "make", "install"
  end

  test do
    system bin/"xboard", "--help"
  end
end
