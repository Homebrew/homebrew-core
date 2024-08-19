class Tdb < Formula
  desc "Trivial DataBase, by the Samba project"
  homepage "https://tdb.samba.org/"
  url "https://www.samba.org/ftp/tdb/tdb-1.4.12.tar.gz"
  sha256 "6ce4b27498812d09237ece65a0d6dfac0941610e709848ecb822aa241084cd7a"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://www.samba.org/ftp/tdb/"
    regex(/href=.*?tdb[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "0e03c60dc4bd4659a2f07d55b3f936fba6a4548732c78a4924b1d9db99567102"
    sha256 cellar: :any,                 arm64_ventura:  "92de590da95180f36ef18df1c1b7a2bae72dfe7cb483c3f7141dd3249e5a4836"
    sha256 cellar: :any,                 arm64_monterey: "3aba84cc7f913c0c2b5e5feab69664575d9fba088dce59edf43ee6c97bf69c8b"
    sha256 cellar: :any,                 sonoma:         "3f9a3c8c78759f6bd917c8ca07b352d4bee7adcdb25d4fb9d2d04296875ce413"
    sha256 cellar: :any,                 ventura:        "9b6d8860e4ff8be0562ff418beca64c47ffc6b6522df88af0fcb1abc6eefd692"
    sha256 cellar: :any,                 monterey:       "4952412921c9e07fa65312f3084f0d218e32d74c949d1062d7a169f073c832e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f83948c0f11a0dfc177f1fcb59ec583bf44639b2c4fab8be95155ec1196c113c"
  end

  uses_from_macos "python" => :build

  conflicts_with "samba", because: "both install `tdbrestore`, `tdbtool` binaries"

  def install
    system "./configure", "--prefix=#{prefix}"
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
