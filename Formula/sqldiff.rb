class Sqldiff < Formula
  desc "Displays the differences between SQLite databases"
  homepage "https://www.sqlite.org/sqldiff.html"
  url "https://www.sqlite.org/2021/sqlite-src-3340100.zip"
  version "3.34.1"
  sha256 "dddd237996b096dee8b37146c7a37a626a80306d6695103d2ec16ee3b852ff49"
  license "blessing"

  livecheck do
    url "https://sqlite.org/news.html"
    regex(%r{v?(\d+(?:\.\d+)+)</h3>}i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "bc9c5f75179eebb911074c3ee03c3b569bcf78fd2b86638426cf80fcc0545ccb" => :big_sur
    sha256 "9604fef23b34f1867541a51fbfbaa562f0c124933243958524c77412cce309b4" => :arm64_big_sur
    sha256 "90f82a12f8b463d6ae92da105788e8a855968250f6ae2ea971e3945d3b3a5cc7" => :catalina
    sha256 "8461ed8c4664c0c026fac15277fa6d2e18586f6be60e0ea71fd6eaaffa27e8d1" => :mojave
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
    system "/usr/bin/sqlite3 #{dbpath} < #{sqlpath}"
    assert_equal "test: 0 changes, 0 inserts, 0 deletes, 0 unchanged",
                 shell_output("#{bin}/sqldiff --summary #{dbpath} #{dbpath}").strip
  end
end
