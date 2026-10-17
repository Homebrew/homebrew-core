class Sqldiff < Formula
  desc "Displays the differences between SQLite databases"
  homepage "https://www.sqlite.org/sqldiff.html"
  url "https://www.sqlite.org/2026/sqlite-src-3540100.zip"
  version "3.54.1"
  sha256 "387e7f6cad4797b17848c07d453dc6606917bb356a6cfe5a3abafd38c240c71b"
  license "blessing"

  livecheck do
    formula "sqlite"
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "b54aad86efe756b1286464bc226fa59310737bc0f2fa72a798d25c657c15a52e"
    sha256 cellar: :any, arm64_tahoe:       "9d3dc5663429f7faed6b5a516f3b1a1eea77f8f54626c92835f93b2281e7b3c2"
    sha256 cellar: :any, arm64_sequoia:     "69bd442fe0b3759a3649dfc54a50f53be13407704238313546e1eba6260f7877"
    sha256 cellar: :any, arm64_linux:       "b5831d5a63961a31111d78242718c22572d6c84157f4e05e24ab456d64813774"
    sha256 cellar: :any, x86_64_linux:      "a645689ea00fc41e50203e9b6c8d53b053335f5e23555bf56a3c28d73b7ad49f"
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
