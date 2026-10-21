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
    sha256 cellar: :any, arm64_golden_gate: "11d4ef987a5d0c4fca47c5b46cbd2359d44ea0f9f9ffb0dc2c0b7da34a629f5a"
    sha256 cellar: :any, arm64_tahoe:       "04b40812624925edba8a9d7bfc847dab6c563218e3788f2c8bd2c74be1a4b351"
    sha256 cellar: :any, arm64_sequoia:     "bcff52a7d419c1c82a5e1df688340285cf6f5f863ced5be5f39e2f42cbe14185"
    sha256 cellar: :any, arm64_linux:       "d3a86d36f753b0b3fccb335c5f58060a3545870b5a0d8af020850bb0ffe8feea"
    sha256 cellar: :any, x86_64_linux:      "83a3951fe62a42797c3e986cb808861ec50cf6b5a58728c67ff502ec75804afc"
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
