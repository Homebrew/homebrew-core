class Tdb < Formula
  desc "Trivial DataBase, by the Samba project"
  homepage "https://tdb.samba.org/"
  url "https://www.samba.org/ftp/tdb/tdb-1.4.14.tar.gz"
  sha256 "144f407d42ed7a0ec1470a40ef17ad41133fe910bce865dd9fe084d49c907526"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://www.samba.org/ftp/tdb/"
    regex(/href=.*?tdb[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "68dbd4f902ea117c3400a462d65dde2fbdb84e031437ad72a3203e17068e534c"
    sha256 cellar: :any,                 arm64_sequoia: "867552b59be50ba8f9acab7d343dfb13ddf5fc01cdb5dad9b65514e126f1be9e"
    sha256 cellar: :any,                 arm64_sonoma:  "2bc5ca7cdcdb65b9a9742315da84853eb713aa703f083777e7bcdb85ae85ab37"
    sha256 cellar: :any,                 arm64_ventura: "ceac8c5018279b2d32ce36c6b8a2e935bcb5021cb35cb7b36990dde903025224"
    sha256 cellar: :any,                 sonoma:        "e57ec266ee5dbe513c5d218f99c366493871569433a3a383565876833fb95807"
    sha256 cellar: :any,                 ventura:       "f8c8fb3c9a322a0473aee4d9dfa4d2cbab77fff71cf529106583a88401f718c8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "16ca3025453f3622fe6f49a74b3f4eb4f7f6b2612392a0819ca89799aacc0bc9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6a312fe0c0bb79b98ce580dab59fd56fcc8306b1adcda8cc7cb34bf2525986bc"
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
