class Sqldiff < Formula
  desc "Displays the differences between SQLite databases"
  homepage "https://www.sqlite.org/sqldiff.html"
  url "https://www.sqlite.org/2022/sqlite-src-3370200.zip"
  version "3.37.2"
  sha256 "486770b4d5f88b5bb0dba540dd6ee1763067d7539dfee18a7c66fe9bb03d16d9"
  license "blessing"

  livecheck do
    formula "sqlite"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "83567b77707dae238259652b3863714b1e96896ea223ceec5d3655c4e3f40e0a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "564a7c08707f25b7f199c5a735e7ba465b75bfe609dd4495524a82bade09a3f5"
    sha256 cellar: :any_skip_relocation, monterey:       "351c8e9f798fea912a0c2c233f9497b857492d437cb61fa4319a89f2922734b9"
    sha256 cellar: :any_skip_relocation, big_sur:        "12088eaa564bc2613b45bd4217a9bf635324e3d8bf89d29c8d5675714b23d222"
    sha256 cellar: :any_skip_relocation, catalina:       "c925d0769454fdd23295a8ff04375bb3b9da1a2d697de4649c08b9871faa7900"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b484a5c5c45a6679d1f9a886c8752f3147ad3906e2f16173ee3bbe5e03f566b7"
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
