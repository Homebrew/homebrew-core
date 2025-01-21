class Tdb < Formula
  desc "Trivial DataBase, by the Samba project"
  homepage "https://tdb.samba.org/"
  url "https://www.samba.org/ftp/tdb/tdb-1.4.12.tar.gz"
  sha256 "6ce4b27498812d09237ece65a0d6dfac0941610e709848ecb822aa241084cd7a"
  license "GPL-3.0-or-later"
  revision 1

  livecheck do
    url "https://www.samba.org/ftp/tdb/"
    regex(/href=.*?tdb[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "a2511841a9090a5d083c4c61dbbda8d378f2237a5638d3c1d2805eec5c08f313"
    sha256 cellar: :any,                 arm64_sonoma:   "087ce2cb58a14fbf681d9fa4fdabef760b2cb59720c10afde568f9924f519542"
    sha256 cellar: :any,                 arm64_ventura:  "636099e08034e97b5d496a621b9d0962dbf98a992f1f925e1d021215d23b64d3"
    sha256 cellar: :any,                 arm64_monterey: "aa58b35c7f2dea471aef80a78fbc1e90361cc6c783fb321ee8781be87a35ee6f"
    sha256 cellar: :any,                 sonoma:         "f83228b9d5dee8e140c701f797644c98d411c5f2196a4ee14f644c3a8a42871f"
    sha256 cellar: :any,                 ventura:        "75ce6baff37c0039b05829dcac010deb642ab420f366e3181615f11092323881"
    sha256 cellar: :any,                 monterey:       "d3b9ac9dfeea91cd2683935359481954544dee063c41e0af0ea6f5b7d06e723f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3757f7a8141b9c77fa03aed41f6718cc5e3ee694d4728cecb467bd21e2453848"
  end

  uses_from_macos "python" => :build

  conflicts_with "jena", because: "both install `tdbbackup`, `tdbdump` binaries"

  def install
    system "./configure", "--bundled-libraries=NONE",
                          "--disable-python",
                          "--disable-rpath",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    testdb = "test-db.tdb"

    # database creation
    pipe_output("#{bin}/tdbtool", "create #{testdb}\ninsert foo bar\n", 0)
    assert_predicate testpath/testdb, :exist?
    assert_match "Database integrity is OK and has 1 records.", pipe_output("#{bin}/tdbtool #{testdb}", "check\n")
    assert_match "key 3 bytes: foo", pipe_output("#{bin}/tdbtool #{testdb}", "keys\n")
  end
end
