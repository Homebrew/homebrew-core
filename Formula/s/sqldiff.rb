class Sqldiff < Formula
  desc "Displays the differences between SQLite databases"
  homepage "https://www.sqlite.org/sqldiff.html"
  url "https://www.sqlite.org/2023/sqlite-src-3430000.zip"
  version "3.43.0"
  sha256 "976c31a5a49957a7a8b11ab0407af06b1923d01b76413c9cf1c9f7fc61a3501c"
  license "blessing"

  livecheck do
    formula "sqlite"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "914d4a98f60e2931aa79233fb9e5a070863754c40c0a413d52750f016d399440"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3ff9603130e8c973655a6b17045782f744bc4a08374d6d5f302b2bf1d91c7151"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "850a51f0123369bb08f738c44a6ce9a71209b832242474ad8cf679829e7aa8df"
    sha256 cellar: :any_skip_relocation, ventura:        "5f3ffbdb189e3d8bcd5f20bc95d50b2919008be8f868296e3c3bf7662e866682"
    sha256 cellar: :any_skip_relocation, monterey:       "8db6ce5d59a61aa5bae791535440eb491df85cf4e7b7ffa24fe88c77e645f2c7"
    sha256 cellar: :any_skip_relocation, big_sur:        "7eb1cade90255ba4a79d95c234edfa854a222d69e7133fd698db3b86c994e1c0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d961fe1f6d6a7e45917295ee41f50468909dd4efbb670f7d1ef7113fffc7c716"
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
