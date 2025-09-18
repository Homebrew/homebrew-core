class Virtualpg < Formula
  desc "Loadable dynamic extension for SQLite and SpatiaLite"
  homepage "https://www.gaia-gis.it/fossil/virtualpg/index"
  url "https://www.gaia-gis.it/gaia-sins/virtualpg-2.0.1.tar.gz"
  sha256 "be2aebeb8c9ff274382085f51d422e823858bca4f6bc2fa909816464c6a1e08b"
  license "MPL-1.1"

  livecheck do
    url :homepage
    regex(/href=.*?virtualpg[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "96423b815a0781a3635f54f02bac58f5b6f97ad735184005b812b7bbe2bda8c6"
    sha256 cellar: :any,                 arm64_sequoia: "8e204f28da296c7deb1ce80831b2bfe8d7456aa540642c554de86f031c7aabad"
    sha256 cellar: :any,                 arm64_sonoma:  "d66f74bcc667dbd4b71f0a9cc8374b3bd17d1ec31e9a112bb61729af23e9479f"
    sha256 cellar: :any,                 arm64_ventura: "666a4cdf6831d4a2d8ca68c9f1674a23215d947dae38c6a5a966f051d172ba4d"
    sha256 cellar: :any,                 sonoma:        "19e10266fbc74189b0acd7ed6e8d9026008ccf7f7731ef66cbe093caf2e79ec8"
    sha256 cellar: :any,                 ventura:       "8f2292bbe12befda53781d168e3a0dc8fdbf3b387e53abf920a25971605b42cc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e8800783153dea8ff0de92a169b8a9810aa69e0682ca0fd567c983d8925e42c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6a3eea533c6345f3ba72760bb196a0c673414e87b02763a4cb48f260acdce535"
  end

  depends_on "libpq"
  depends_on "sqlite"

  def install
    # New SQLite3 extension won't load via SELECT load_extension('mod_virtualpg');
    # unless named mod_virtualpg.dylib (should actually be mod_virtualpg.bundle)
    # See: https://groups.google.com/forum/#!topic/spatialite-users/EqJAB8FYRdI
    # needs upstream fixes in both SQLite and libtool
    inreplace "configure",
              "shrext_cmds='`test .$module = .yes && echo .so || echo .dylib`'",
              "shrext_cmds='.dylib'"

    system "./configure", "--disable-silent-rules",
                          "--with-pgconfig=#{Formula["libpq"].opt_bin}/pg_config",
                          *std_configure_args
    system "make", "install"
  end

  test do
    # Verify mod_virtualpg extension can be loaded using Homebrew's SQLite
    system "echo", "\" SELECT load_extension('#{opt_lib}/mod_virtualpg');\" | #{Formula["sqlite"].opt_bin}/sqlite3"
  end
end
