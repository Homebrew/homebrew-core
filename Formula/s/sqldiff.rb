class Sqldiff < Formula
  desc "Displays the differences between SQLite databases"
  homepage "https://www.sqlite.org/sqldiff.html"
  url "https://www.sqlite.org/2026/sqlite-src-3530100.zip"
  version "3.53.1"
  sha256 "1b2b5755d9064c4d5d1b0bf5307b48b089963e291c40cc7351318aa1b61c460e"
  license "blessing"

  livecheck do
    formula "sqlite"
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "856fd307bc8f740d9c446df16976cf49b2ce539fb6eb91c971c203887ea4fdf7"
    sha256 cellar: :any,                 arm64_sequoia: "3d8a16cb28289296bd03f05d698608745790d2bda90a87d969c869df6385ed2c"
    sha256 cellar: :any,                 arm64_sonoma:  "53aa43246ebaf21c4aedf132b510e1cf4901ed67c461509bef8e8d7e2e6b48c1"
    sha256 cellar: :any,                 tahoe:         "d4f1f52e5b1f7b3b7664dad5c701b6260f43cc51094c4a8126042c56a4af048b"
    sha256 cellar: :any,                 sequoia:       "67c4a5da3170c18417054ab671bcde34a568f11faf97ea8f29d86897e0c3f928"
    sha256 cellar: :any,                 sonoma:        "57bb0710dadc07b8060a1650372c53f1204d648f1eb9de19eccc4014641bf463"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "15e2248ffa4ee80aab4f766d483d719fcb1ff50749282f519afdb15915351e38"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f200da8e66a5fcdedc32f58b1ffd18388809fccedbbf6941b92dbedde409547a"
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
