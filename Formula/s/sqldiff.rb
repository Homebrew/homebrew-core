class Sqldiff < Formula
  desc "Displays the differences between SQLite databases"
  homepage "https://www.sqlite.org/sqldiff.html"
  url "https://www.sqlite.org/2026/sqlite-src-3530200.zip"
  version "3.53.2"
  sha256 "cafff764c03f6d720968f746e2f47a986bbf12bf4c18904f1eb131c0b0b592d3"
  license "blessing"

  livecheck do
    formula "sqlite"
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "9c43d6eedad9b39cee4de40aa52abdfe109e0e9870d1afad1b708d7f84e71498"
    sha256 cellar: :any, arm64_sequoia: "6648b45283744ee986de6dbb8da6d8052fd55e5f030abc588a522e4f0e50a91b"
    sha256 cellar: :any, arm64_sonoma:  "c6bea16b05135b6aeed90f5cbe0ef5cbb82484e37cce2bd7ce8e1520460790fc"
    sha256 cellar: :any, tahoe:         "a453dbe6385dd4dd39cb4af2cd77dce14362d896b820dcb1cd9d7080d2f9a09a"
    sha256 cellar: :any, sequoia:       "f004bf923b01ef29f548dd60381318dda547f8ee9e324742c828f34308f13e68"
    sha256 cellar: :any, sonoma:        "7462f1ee1dfb7ac9c0df81f7f5dda943c9640a39dffb83e55c89d3f06ea6cf65"
    sha256 cellar: :any, arm64_linux:   "23db90d61e1eb868bf05a9478c535b353f2f609479fea26b885e1be1e906bf65"
    sha256 cellar: :any, x86_64_linux:  "b8b7e59d52b3d6a29e7a4710b7ac2e13c2ffe37b3530660f44bf8fcf819bb76f"
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
