class Sqldiff < Formula
  desc "Displays the differences between SQLite databases"
  homepage "https://www.sqlite.org/sqldiff.html"
  url "https://www.sqlite.org/2026/sqlite-src-3530300.zip"
  version "3.53.3"
  sha256 "bb80bf8a3bffc19241ce8aba5a4bc74e9c3980013cb0b5f0f0976a99516942af"
  license "blessing"

  livecheck do
    formula "sqlite"
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "a9e92e59e39899ca4cc479c85c4ed514117c8a5b7d35e0657b177561bdf61698"
    sha256 cellar: :any, arm64_sequoia: "a9de38949969a71a84027346e934e9f33ffdaa84808a94c8607c066b67586731"
    sha256 cellar: :any, arm64_sonoma:  "b793bad311851fbc4bc9d25ed3eb9b1c9dd1b3c459b7f2bc98ff3809fc3b46fb"
    sha256 cellar: :any, tahoe:         "8e45930482c02cbd6a8fb6704d7981428017c7f261959b5cb22892278dd12293"
    sha256 cellar: :any, sequoia:       "f85013034ed095f88a0d005ee00b56ea8892c63ebcdc9589651a0ba44c467cc7"
    sha256 cellar: :any, sonoma:        "c551a8ea1112a22d1d38655eb62e6e6930da5b074adcb0b38beca9bb4276a50e"
    sha256 cellar: :any, arm64_linux:   "fe9ee8b2f3840918d0c50291f4257d54d4330608e44e70901c666ca23414eb67"
    sha256 cellar: :any, x86_64_linux:  "f17e021c6a1204f5963b7d25764793254d927fdcc807de0f426b170970971ba3"
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
