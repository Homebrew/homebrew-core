class Sqldiff < Formula
  desc "Displays the differences between SQLite databases"
  homepage "https://www.sqlite.org/sqldiff.html"
  url "https://sqlite.org/2022/sqlite-src-3390100.zip"
  version "3.39.1"
  sha256 "366c7abbee5dbe8882cd7578a61a6ed3f5d08c5f6de3535a0003125b4646cc57"
  license "blessing"

  livecheck do
    formula "sqlite"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0fa9f3587b40d9aa0c435d68c2a010d9de917bb86724160731f2161c8cc7516c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3a2a597b137bf1b60ed245d4932d826072cafe88128a1a6c167edfb2f4acfc5e"
    sha256 cellar: :any_skip_relocation, monterey:       "ad13051e58b7c3e4896a49b6da6c8ec2054d9021738d973c7115fdbf9fa8c0e9"
    sha256 cellar: :any_skip_relocation, big_sur:        "85d53b8785f2629e9f7c78f6c43fbe904047a48b927aa92952e061ae662fad35"
    sha256 cellar: :any_skip_relocation, catalina:       "ca357355cf05ab18d49c24f6ee58d32f94931964a93be822d48a1797305505e6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "361a72476e26366889ca4638d470fd74c1ea35366d7ed9fd77def6955b4f5bdd"
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
