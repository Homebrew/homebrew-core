class Tdb < Formula
  desc "Trivial DataBase, by the Samba project"
  homepage "https://tdb.samba.org/"
  url "https://www.samba.org/ftp/tdb/tdb-1.4.15.tar.gz"
  sha256 "fba09d8df1f1b9072aeae8e78b2bd43c5afef20b2f6deefa633aa14a377a8dd2"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://www.samba.org/ftp/tdb/"
    regex(/href=.*?tdb[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "263f2b310f2be1f0aeb5b98357dc28c88fbb6a46d116def650e7a30c05f3608e"
    sha256 cellar: :any,                 arm64_sequoia: "73ab9ee5b4a954338efb2cded87651f64984a2ea27b898f4b4f584a8fa3776ea"
    sha256 cellar: :any,                 arm64_sonoma:  "6036f32cf47d3abf27e88af33bc95e0b00156eb3f1fb8ab9c3a63ed075d1d96b"
    sha256 cellar: :any,                 sonoma:        "960e975c3de42888b3b658be681a508da6b995997be2b5f7ea09bd7a07d4fd66"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d346592209e61e26edf76232e05e41f07deecbb3430e68f0d1bf6658a674b649"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b07d10b7909161e804d6d707d300249a23bb86f9aee2cdf313cf92be772a1f47"
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
