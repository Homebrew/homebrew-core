class Sqldiff < Formula
  desc "Displays the differences between SQLite databases"
  homepage "https://www.sqlite.org/sqldiff.html"
  url "https://www.sqlite.org/2021/sqlite-src-3350400.zip"
  version "3.35.4"
  sha256 "77007915a87ccc8a653d5f3d2d3a3cca89807641965c2a6e2958bea964ea02a4"
  license "blessing"

  livecheck do
    url "https://sqlite.org/news.html"
    regex(%r{v?(\d+(?:\.\d+)+)</h3>}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "a1f7137a288f60017ee75a622ade4d9217a5dc95221fd91173cf73b53b98b9ea"
    sha256 cellar: :any_skip_relocation, big_sur:       "bc5834f925f547dd1af5f9ae7a51e609858f7b33a4fe2e661f4257334a9dbea7"
    sha256 cellar: :any_skip_relocation, catalina:      "1e8f84f839b02b4758e6b2f2bfa50dfa9d7240d29befd4fd1bb72a71cef2e149"
    sha256 cellar: :any_skip_relocation, mojave:        "c45db4be0569ea85e6777701a9d89597a7d797b08b56d457d19bc5c6401a0e51"
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
