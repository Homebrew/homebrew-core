class Sqldiff < Formula
  desc "Displays the differences between SQLite databases"
  homepage "https://www.sqlite.org/sqldiff.html"
  url "https://www.sqlite.org/2024/sqlite-src-3450200.zip"
  version "3.45.2"
  sha256 "4a45a3577cc8af683c4bd4c6e81a7c782c5b7d5daa06175ea2cb971ca71691b1"
  license "blessing"

  livecheck do
    formula "sqlite"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "dbce2785d1f21454d9a93333dcc85ed99e5ee4aaf4e6f5b72cc0fc99714cad55"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "460b3fd63cc04d1678eeaa392d1a4dd9d85fa2d388ec48aacaca06c313cd5782"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bb1b8df1ddb6a00cc20e2f5858ec7a7689eefc55d4c7c21b250ac914cc954cc8"
    sha256 cellar: :any_skip_relocation, sonoma:         "850bf6150af025adfdf116619c4487527c35b9e7739f697bdb18648fba14d940"
    sha256 cellar: :any_skip_relocation, ventura:        "a95469b4bee6b5a1896a1e8c26c30312bce8c4d57a50b7284f0785c894390fa6"
    sha256 cellar: :any_skip_relocation, monterey:       "82d165ec09bbee443607ec98d9850583f89d027c7ba22a5eb85b74df0795ce35"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8ce87dddddcf7e6db504877b90ff0c574d2ed262edfa6662080f5fdf31680dea"
  end

  uses_from_macos "tcl-tk" => :build
  uses_from_macos "sqlite" => :test

  def install
    system "./configure", "--disable-debug", "--prefix=#{prefix}"
    system "make", "sqldiff"
    bin.install "sqldiff"
  end

  test do
    dbpath = testpath/"test.sqlite"
    sqlpath = testpath/"test.sql"
    sqlpath.write "create table test (name text);"
    system "sqlite3 #{dbpath} < #{sqlpath}"
    assert_equal "test: 0 changes, 0 inserts, 0 deletes, 0 unchanged",
                 shell_output("#{bin}/sqldiff --summary #{dbpath} #{dbpath}").strip
  end
end
