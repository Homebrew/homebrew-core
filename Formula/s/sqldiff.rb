class Sqldiff < Formula
  desc "Displays the differences between SQLite databases"
  homepage "https://www.sqlite.org/sqldiff.html"
  url "https://sqlite.org/2026/sqlite-src-3530000.zip"
  version "3.53.0"
  sha256 "fbc30cdbfcfa42c78fe7bddd3fd37ab8995369a31d39097a5d0633296c0b6e65"
  license "blessing"

  livecheck do
    formula "sqlite"
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "fa732afdd6482d2dda8b4667a8a93029421dd57622e16451c7355ae613dfd90a"
    sha256 cellar: :any,                 arm64_sequoia: "f003ba14958f8857e8d425ec5c86020464cc0654aa4eee22047992f3f9b67ff7"
    sha256 cellar: :any,                 arm64_sonoma:  "3d658610010218be62a4b3c63c2a4f5f00638242d11e25ce05843df916b68d3d"
    sha256 cellar: :any,                 tahoe:         "49050159aafcac43601c9a86a27b65ebe5ac0c97124c6358342df050e4263706"
    sha256 cellar: :any,                 sequoia:       "b91134952b623f9153c26ad56650e7ed45d3a2e3bc2e9b90a3e0e126b81e52aa"
    sha256 cellar: :any,                 sonoma:        "6e9eb032196010f93853593bbbfc5c287979066eef54c1e766a8b5db412810a7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0d4d0bd3537ceadfeb293f40d3fde8b30a9d9d86523faa7ec39f417237a383f7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "087c7d7394950da659c5fc0b0aabbcfa51db90849921b7733608a5db0170e5c9"
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
