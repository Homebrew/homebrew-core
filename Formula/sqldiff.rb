class Sqldiff < Formula
  desc "Displays the differences between SQLite databases"
  homepage "https://www.sqlite.org/sqldiff.html"
  url "https://www.sqlite.org/2021/sqlite-src-3370100.zip"
  version "3.37.1"
  sha256 "7168153862562d7ac619a286368bd61a04ef3e5736307eac63cadbb85ec8bb12"
  license "blessing"

  livecheck do
    formula "sqlite"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "72353be341649f1a0497989e172920803b8ae7661424aa296501d239b0a078c0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c553c869f3381e1956617ab3ccf4f88485b79053748ad1e851269c6818cad4b3"
    sha256 cellar: :any_skip_relocation, monterey:       "962dd3ee4729854f3913bb375c6fa4d0c6adfd4d7b87a5b3a4a99b543a2b3c77"
    sha256 cellar: :any_skip_relocation, big_sur:        "88f8a911eec18ab21f5f414bd9bdca0a8f3cfe878a2dd3a6ef50d6513af7a0a2"
    sha256 cellar: :any_skip_relocation, catalina:       "fbfa768a058d763f9b9f5f9c5ee6615d738f1f9944a552dd6e806986d77108a3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "53678ad0e79051ff1710edccc4bfb669b87b78761a48e4a37840764275a8331f"
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
