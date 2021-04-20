class Sqldiff < Formula
  desc "Displays the differences between SQLite databases"
  homepage "https://www.sqlite.org/sqldiff.html"
  url "https://www.sqlite.org/2021/sqlite-src-3350500.zip"
  version "3.35.5"
  sha256 "f4beeca5595c33ab5031a920d9c9fd65fe693bad2b16320c3a6a6950e66d3b11"
  license "blessing"

  livecheck do
    url "https://sqlite.org/news.html"
    regex(%r{v?(\d+(?:\.\d+)+)</h3>}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "d41f6977dc4249390db5ac5283c3514967903967b548a107457d22365e477c04"
    sha256 cellar: :any_skip_relocation, big_sur:       "def8ed3bbbc404d52ae4989380c8457279d421249aa770d8354729beb3ebf7aa"
    sha256 cellar: :any_skip_relocation, catalina:      "0aed32b0e14c0eaad01412684ee0c4498f0077922adf304aea54a2e759f0648f"
    sha256 cellar: :any_skip_relocation, mojave:        "9789c76c28ad585e233e5f605f313a0414d9b099b96c7556ddbe9de1404733c1"
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
