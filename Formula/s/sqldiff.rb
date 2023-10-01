class Sqldiff < Formula
  desc "Displays the differences between SQLite databases"
  homepage "https://www.sqlite.org/sqldiff.html"
  url "https://www.sqlite.org/2023/sqlite-src-3430100.zip"
  version "3.43.1"
  sha256 "22e9c2ef49fe6f8a2dbc93c4d3dce09c6d6a4f563de52b0a8171ad49a8c72917"
  license "blessing"

  livecheck do
    formula "sqlite"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fc34cf0ffd79222ae2a94e0afa17ffe91eaa32df836b12e26224366ca0d9f28a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3476f48bf9a54aa1368eab7c74d4ef550b44be1da740b5722e882dfe6874b082"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c47c881bb74ad862d2df838dc137cb2f8974dfc92b065bce3dd532d816e31e15"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "849122883db4ecc5f35ab561ad798fcfca53ac0fbf3ca0213b6d0d6f4677abdd"
    sha256 cellar: :any_skip_relocation, sonoma:         "59ffb930cb4aaf3ca6012060a1d1cf3ca93759e9102a666c5b908d6b39091e8a"
    sha256 cellar: :any_skip_relocation, ventura:        "18997809467579e4169625d093f3237d1523a827c28579bdcf7f2484dece2a43"
    sha256 cellar: :any_skip_relocation, monterey:       "67d953e78cbd839b65336159f51e7c0503dd496dd2b0a345fed72402def46cf8"
    sha256 cellar: :any_skip_relocation, big_sur:        "14eaab3dbd2c599352d4e747ec00e25b8ad007f005b7ebb10582cd9e1d996b88"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d113f8deb865e2891407d27254e1c131244cb779c0f11b25efc49a7a0b4498e7"
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
