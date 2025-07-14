class Sqldiff < Formula
  desc "Displays the differences between SQLite databases"
  homepage "https://www.sqlite.org/sqldiff.html"
  url "https://www.sqlite.org/2025/sqlite-src-3500200.zip"
  version "3.50.2"
  sha256 "091eeec3ae2ccb91aac21d0e9a4a58944fb2cb112fa67bffc3e08c2eca2d85c8"
  license "blessing"

  livecheck do
    formula "sqlite"
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "eca6ceacee727c2e0caff6f228a911ee53192664ae791b823af8187aa2f767c8"
    sha256 cellar: :any,                 arm64_sonoma:  "84c1f42af8b2ff1d4503fb6a24b9d35a9e80e3be497370e441956d96324ba085"
    sha256 cellar: :any,                 arm64_ventura: "d33e9d0b98eba81efc9c1a15da61062c85f5c4f9341d45c661133ec25b69e97e"
    sha256 cellar: :any,                 sequoia:       "b278756dbb30c8365c097a8380e4e21790f6ba3458f7de61a24f577bc9cad20d"
    sha256 cellar: :any,                 sonoma:        "ce1713d9f2dc546aa3bd0e98c19544535db335d62114fab7057d3570e6299f80"
    sha256 cellar: :any,                 ventura:       "f1b49d09a9ebac5c9c4f890c281cc6f1d7712c133f28f8b4e8deb5f8cfac6d36"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "aae50e810325c053026fac7e1b7d635a5648d8d85b958dcd0c3705809db1bf0f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "585039b9e7ebd237459eb4a4c3692142547f9a2ec9f5183755441c7f4f9c3f28"
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
