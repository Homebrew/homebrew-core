class Sqldiff < Formula
  desc "Displays the differences between SQLite databases"
  homepage "https://www.sqlite.org/sqldiff.html"
  url "https://sqlite.org/2022/sqlite-src-3380100.zip"
  version "3.38.1"
  sha256 "177aefda817fa9f52825e1748587f7c27a9b5e6b53a481cd43461f2746d931d8"
  license "blessing"

  livecheck do
    formula "sqlite"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e0ca53e06b43dd138446af9acec32fcca62502dd03d021feb496f8a1d7ff3c39"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1c8eb1f1da921c54878bf07c7b1c9b0bcf79832c0711dab2a86235c3fb04a2f1"
    sha256 cellar: :any_skip_relocation, monterey:       "045c108cb5402b1bf07d988ce0b6d1b82dfb805da85b63b98cfc9647c9588272"
    sha256 cellar: :any_skip_relocation, big_sur:        "b521093575ef01566a108f335309c6fab2e26fef74426d93bae2ac566558d389"
    sha256 cellar: :any_skip_relocation, catalina:       "650869995cc70e0deb88acdf2086eb1475843952cabeaeb2a9ae812a523edcfe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "15dcc8fef07e665837ecfa2fc6a109688e86c3f714dd8592f57bae7c77c0a1d6"
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
