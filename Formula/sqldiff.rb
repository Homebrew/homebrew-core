class Sqldiff < Formula
  desc "Displays the differences between SQLite databases"
  homepage "https://www.sqlite.org/sqldiff.html"
  url "https://sqlite.org/2022/sqlite-src-3390400.zip"
  version "3.39.4"
  sha256 "02d96c6ccf811ab9b63919ef717f7e52a450c420e06bd129fb483cd70c3b3bba"
  license "blessing"

  livecheck do
    formula "sqlite"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d48e341c95d0feedea0384fd7d338d562db5c6ce05a0a2ad1e30909cd2b52087"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cf85827b626fc6e74c319eecf9c6d8425ea34206a29ffa7618dd9e9f1132584b"
    sha256 cellar: :any_skip_relocation, monterey:       "02106198e2e436247cdf59414c95f21153e2941ffa67d25057dba02c6799737f"
    sha256 cellar: :any_skip_relocation, big_sur:        "4369ac018b77fd56ec16b3616974dc90bf40fd96ea8210fb32c5562abd846cc8"
    sha256 cellar: :any_skip_relocation, catalina:       "72d7f75153fa753eb4d5b83dd7d5f91238da8ba80f2a265f40c7b595e9abb510"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b534ffca342ddd9ec0c156be47d4e18418920d4ef02081f7fcfadc8a1877634c"
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
