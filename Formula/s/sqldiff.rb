class Sqldiff < Formula
  desc "Displays the differences between SQLite databases"
  homepage "https://www.sqlite.org/sqldiff.html"
  url "https://sqlite.org/2026/sqlite-src-3510300.zip"
  version "3.51.3"
  sha256 "f8a67a1f5b5cae7c6d42f0994ca7bf1a4a5858868c82adc9fc1340bed5eb8cd2"
  license "blessing"

  livecheck do
    formula "sqlite"
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "6011d195cd289485a143042109707c3e06e495a83ec3b47a2a5919f4f3bfa9d3"
    sha256 cellar: :any,                 arm64_sequoia: "1b8881e73d629473fb12d8d71ebd6438e7189e845dfa46b62efe1f5b2c725b29"
    sha256 cellar: :any,                 arm64_sonoma:  "13650850b5303a6d9db47e24cb3e3dc9afb84648fb1ecd299ae2e80a8bf6c090"
    sha256 cellar: :any,                 tahoe:         "d23b3975efbe1ff1c2b26c9bf7c89f33337c733f332ca640f90b73b90f8db154"
    sha256 cellar: :any,                 sequoia:       "29916a1618cf2af91bc6bf40824a50f70ace1a42fefe5ccca7113811d5566433"
    sha256 cellar: :any,                 sonoma:        "1d1f3688ae4ed5c9320ecc5b3d78484497077ee8e4765109c031958c750dd699"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6c1e27d4fc8084d6a04af117e81e867895462c0f85ee794127fcefef75d546ce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "add8d08c4a3f7ad6995d2e615f95609d1fdfdb88c6a343931bf78828fc799408"
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
