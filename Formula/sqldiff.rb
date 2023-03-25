class Sqldiff < Formula
  desc "Displays the differences between SQLite databases"
  homepage "https://www.sqlite.org/sqldiff.html"
  url "https://www.sqlite.org/2023/sqlite-src-3410200.zip"
  version "3.41.2"
  sha256 "87191fcecb8b707d9a10edb13607686317d7169c080b9bdc5d39d06358376ccc"
  license "blessing"

  livecheck do
    formula "sqlite"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "010bcdb7bee00abe36f9cf23d1a84bea1e6038b0c4f1ac41978a2a9f9d24d04b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f489b99a916aff96a41522cba78df3d96eb1575abdef9ae4efbceeae2a47f74c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7b97083eac3a45cd9f0233ee7810c8c8c927a96fa4731f24b54c501c95ffe8fc"
    sha256 cellar: :any_skip_relocation, ventura:        "bec5293157dd11b46756da12e0e3229c8f83e5596a0fa5d1fe773c1d07afd8ab"
    sha256 cellar: :any_skip_relocation, monterey:       "ad567985e427f8602202b4abdd37e7699f25a8f8cb6c0ad87adc48cce57d3aa8"
    sha256 cellar: :any_skip_relocation, big_sur:        "549c2d6b1ad73f34b0655a5b8b63a7d0566e27b3ab9f96c140686a483ecabc75"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b6c5bdf362496cd2545b0a8b57a4e036fbc9d9774401c52b18e2b586fa4176ef"
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
