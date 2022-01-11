class Sqldiff < Formula
  desc "Displays the differences between SQLite databases"
  homepage "https://www.sqlite.org/sqldiff.html"
  url "https://www.sqlite.org/2022/sqlite-src-3370200.zip"
  version "3.37.2"
  sha256 "486770b4d5f88b5bb0dba540dd6ee1763067d7539dfee18a7c66fe9bb03d16d9"
  license "blessing"

  livecheck do
    formula "sqlite"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8913a391d6a20bf36432602bb9325d2432e8d54d088a66cd8f67cd2ec0b7223a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b3cad01951c30e1a746673e3d606d3dd7afe0184cd8b7a2000f5c53a86faf6a2"
    sha256 cellar: :any_skip_relocation, monterey:       "d77097d821d01c6dead9ef49b861f28cfc785f44ad63c774d2efca6884d3f292"
    sha256 cellar: :any_skip_relocation, big_sur:        "2da1cc1a8ff3645135fae493de819c0cead1f08f0e5ab8344c9887cc6a0c72c9"
    sha256 cellar: :any_skip_relocation, catalina:       "6e75ff03fac19722671963c1d3f95116ff12396c88810b303225ace221de4ab9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2f55b8df9f966700168ca1c4a523702ea548c0e3e8626fd7ebc6d109ce164a8e"
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
