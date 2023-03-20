class Texinfo < Formula
  desc "Official documentation format of the GNU project"
  homepage "https://www.gnu.org/software/texinfo/"
  url "https://ftp.gnu.org/gnu/texinfo/texinfo-7.0.2.tar.xz"
  mirror "https://ftpmirror.gnu.org/texinfo/texinfo-7.0.2.tar.xz"
  sha256 "f211ec3261383e1a89e4555a93b9d017fe807b9c3992fb2dff4871dae6da54ad"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_ventura:  "85b1f14167d0b7eaf65a5be395f5d3a75d27e3182243c775d9cd1929c96a36df"
    sha256 arm64_monterey: "054152111b0a771c4da4b68c02515e0177e5b5e958392446fd35336088cf7378"
    sha256 arm64_big_sur:  "b1dbf9951b12ad2dcd7d7737cfb1e4eb3415f0c8f2b2c9c3f7d347838cb69543"
    sha256 ventura:        "236e5a03b4e41c71e08d3e7f8be76ff8ac2fdde19fcae03bae9b16e77d5ce432"
    sha256 monterey:       "21884b42af2e3e3018242c3334c180dcb5642798833bda3b4168d7a59a5c2407"
    sha256 big_sur:        "f6745b887f400b3031d9c5e051b7f1f946c3c3063f2ed3fd8f8d7ef72bd2f7ff"
    sha256 x86_64_linux:   "93a9e18b2b736e5c78eb7f2b8708982e2ad8ca5861af07b2d179e8514115a0bc"
  end

  uses_from_macos "ncurses"
  uses_from_macos "perl"

  # texinfo has been removed from macOS Ventura.
  on_monterey :or_older do
    keg_only :provided_by_macos
  end

  on_system :linux, macos: :high_sierra_or_older do
    depends_on "gettext"
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-install-warnings",
                          "--prefix=#{prefix}"
    system "make", "install"
    doc.install Dir["doc/refcard/txirefcard*"]
  end

  test do
    (testpath/"test.texinfo").write <<~EOS
      @ifnottex
      @node Top
      @top Hello World!
      @end ifnottex
      @bye
    EOS
    system "#{bin}/makeinfo", "test.texinfo"
    assert_match "Hello World!", File.read("test.info")
  end
end
