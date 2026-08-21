class Sqldiff < Formula
  desc "Displays the differences between SQLite databases"
  homepage "https://www.sqlite.org/sqldiff.html"
  url "https://www.sqlite.org/2026/sqlite-src-3530400.zip"
  version "3.53.4"
  sha256 "d18fa15aec74d8c17e1463f861095adc01b5ad190256acb4f91d22f0368d232b"
  license "blessing"

  livecheck do
    formula "sqlite"
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "b29ff5f2b5f8c7c891a559c8e3a76a930cbeeed75681edb951a36247aa9f504d"
    sha256 cellar: :any, arm64_sequoia: "d483463ce3270b822df550dceed22843067f96af264aca84f563bd8b9559ed28"
    sha256 cellar: :any, arm64_sonoma:  "f8f24bd21e56634d5c50de31c5b3b7ac2f8705e3200347dbad604cfcb5967043"
    sha256 cellar: :any, tahoe:         "8b746d87c32a0b5dcd07d1918bd8d7308ab8696946ce0c3bd765377785e67ad7"
    sha256 cellar: :any, sequoia:       "af6d4981604415449fba6f6a01bfcf9781edcf00d16c53128614e62d1da98b4b"
    sha256 cellar: :any, sonoma:        "0355bfda28a6a3ee7515d44af4375ff98a6b875e0f8cf4f6d162f70ada679093"
    sha256 cellar: :any, arm64_linux:   "0c73b193a430e610ddce5803cd25bf9a0314cfb42caedaef774ba3b891227fde"
    sha256 cellar: :any, x86_64_linux:  "237139ce82ff651b0877370a885175d83c60d43ee00170ebec7e184d80fa3188"
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
