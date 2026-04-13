class SqliteAnalyzer < Formula
  desc "Analyze how space is allocated inside an SQLite file"
  homepage "https://www.sqlite.org/"
  url "https://sqlite.org/2026/sqlite-src-3530000.zip"
  version "3.53.0"
  sha256 "fbc30cdbfcfa42c78fe7bddd3fd37ab8995369a31d39097a5d0633296c0b6e65"
  license "blessing"

  livecheck do
    formula "sqlite"
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "696e9ee8a6d23204712fa6c707c663e1bcf48904fc20a540ecf60844eef98d9b"
    sha256 cellar: :any,                 arm64_sequoia: "a3e3052d704e4fb041bc6d994a91bd89404c8b83686a574bc9c1ea8a2239ac43"
    sha256 cellar: :any,                 arm64_sonoma:  "0cdd373500d597dbc25906c0fd8566bff60e5ef2b2ae8a2cca09ca4e27ffa2de"
    sha256 cellar: :any,                 sonoma:        "cbb76d77346f6375833d8ba8043ab8ff9369b00fe643f846e5eb6b7d5573ad35"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f66a48f14f8f26d4dc878707c0bad0722bec377549bcd26b5368f4e40e5f74c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "87bbb90408ce0e85d1966cf19ea1e54bb8e90bb33c2e9a655be0fa59f36dd8db"
  end

  depends_on "tcl-tk"
  uses_from_macos "sqlite" => :test

  on_macos do
    depends_on "libtommath"
  end

  def install
    system "./configure", "--with-tcl=#{Formula["tcl-tk"].opt_lib}", *std_configure_args
    system "make", "sqlite3_analyzer"
    bin.install "sqlite3_analyzer"
  end

  test do
    dbpath = testpath/"school.sqlite"
    sqlpath = testpath/"school.sql"
    sqlpath.write <<~SQL
      create table students (name text, age integer);
      insert into students (name, age) values ('Bob', 14);
      insert into students (name, age) values ('Sue', 12);
      insert into students (name, age) values ('Tim', 13);
    SQL
    system "sqlite3 #{dbpath} < #{sqlpath}"
    system bin/"sqlite3_analyzer", dbpath
  end
end
