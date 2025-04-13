class Tdb < Formula
  desc "Trivial DataBase, by the Samba project"
  homepage "https://tdb.samba.org/"
  url "https://www.samba.org/ftp/tdb/tdb-1.4.13.tar.gz"
  sha256 "5ee276e7644d713e19e4b6adc00b440afb5851ff21e65821ffaed89e15a5e167"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://www.samba.org/ftp/tdb/"
    regex(/href=.*?tdb[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "1bd7cd583b2c42a4f0e634859622b0cac4a48f35410650bf0573b74afff49e20"
    sha256 cellar: :any,                 arm64_sonoma:  "fea78e4678ef0a6f84e3a6cd57713f150f01e73bf81609f54102ef0ada8467ae"
    sha256 cellar: :any,                 arm64_ventura: "f77f95a5940ca7a4a40ef08d6611239c5885426311e4f0b3c321a6429d6891a7"
    sha256 cellar: :any,                 sonoma:        "4152b5bb64a94971afa35b8e7c17ea6d3dba0efafe2031617f53765cd158dc0f"
    sha256 cellar: :any,                 ventura:       "c9e83486f202b33c0dd32f8debba7b8562374766c2488b630d55d7da8df3dc07"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "391ffd0d0824c218c0f175f53511aedd0520d5e5031c971a5a6d096efdf482fd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "62725a4b2245ffdeb4792e1032e09f2ec24824b70363c2ca50c6f024a3f4acf0"
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
    assert_path_exists testpath/testdb
    assert_match "Database integrity is OK and has 1 records.", pipe_output("#{bin}/tdbtool #{testdb}", "check\n")
    assert_match "key 3 bytes: foo", pipe_output("#{bin}/tdbtool #{testdb}", "keys\n")
  end
end
