class SqliteAnalyzer < Formula
  desc "Analyze how space is allocated inside an SQLite file"
  homepage "https://www.sqlite.org/"
  url "https://sqlite.org/2025/sqlite-src-3510000.zip"
  version "3.51.0"
  sha256 "5330719b8b80bf563991ff7a373052943f5357aae76cd1f3367eab845d3a75b7"
  license "blessing"

  livecheck do
    formula "sqlite"
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "37216928d4458f70d823d7d9e5d73d146de42c57021d8db9c5f8da45fd648317"
    sha256 cellar: :any,                 arm64_sequoia: "aaae0b43fb4fb9c6e32a5ef0c181640b276d7c2be9da8d4757fc31408b693747"
    sha256 cellar: :any,                 arm64_sonoma:  "063e40b00794727904d3b98c66489568c8681b93413301447330eabf6d6d5e8d"
    sha256 cellar: :any,                 sonoma:        "15f81a02dc4561553ca7dc4f81443137d6f72966fe759f9a443786f5825b00fc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e985647c342b7bb5ef5487ae432b001556ca8cd75a25a3e2ba999a88c5eca585"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6e8d1a04cdcb19bc1971d996bfb77048c5f7da7a4b60cbc350846433455d9643"
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
