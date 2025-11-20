class Sqldiff < Formula
  desc "Displays the differences between SQLite databases"
  homepage "https://www.sqlite.org/sqldiff.html"
  url "https://sqlite.org/2025/sqlite-src-3510000.zip"
  version "3.51.0"
  sha256 "5330719b8b80bf563991ff7a373052943f5357aae76cd1f3367eab845d3a75b7"
  license "blessing"

  livecheck do
    formula "sqlite"
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "9bdbc72654b07c28b7c2d7899689d06be35b1390fb601beef78b092858002570"
    sha256 cellar: :any,                 arm64_sequoia: "d4536500e498ff7477a41526d6ad06ca646ff44de56ab44aa1a15aa13bd0b23e"
    sha256 cellar: :any,                 arm64_sonoma:  "d88385a51b90e1f18cefab179e9047f92e6f9ea65d04d687a44bd6e17f92a990"
    sha256 cellar: :any,                 tahoe:         "f822fb094ea2097535f0209ce81fd44c4e61f494a38c6e2e9e5f75711ecac0ea"
    sha256 cellar: :any,                 sequoia:       "d66870407c73b940df7d74a627920480de0028537e768aae7f99f8d74a377968"
    sha256 cellar: :any,                 sonoma:        "f3d0edd20210707ab2d3448171a73a82449ad653a99a7e080a0abfa50d380250"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3eaa7d8bd8029fa16107595184e1bf2d8fa847317cf14732082684ac3fc85056"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "89498745278181bf560a9ea4f8ff8a5135b0305a1fb9d8c3d0a2b482a7df8624"
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
