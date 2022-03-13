class SqliteAnalyzer < Formula
  desc "Analyze how space is allocated inside an SQLite file"
  homepage "https://www.sqlite.org/"
  url "https://sqlite.org/2022/sqlite-src-3380100.zip"
  version "3.38.1"
  sha256 "177aefda817fa9f52825e1748587f7c27a9b5e6b53a481cd43461f2746d931d8"
  license "blessing"

  livecheck do
    formula "sqlite"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "63257d0bd964e7084f508bd387e8ac3f86863b67996c93ccee573ce904f78c5d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9e1376a8f401437718674689f6915c072a8e2fc5348213530695cecd60812584"
    sha256 cellar: :any_skip_relocation, monterey:       "0ea94bc8eddf9e642dbadf08c48dddf111cb395b98befa8417b470c268ab7b99"
    sha256 cellar: :any_skip_relocation, big_sur:        "401e89b30d7e37af7d2d4aed18962ce39805f85e1720da8c99969beb071af272"
    sha256 cellar: :any_skip_relocation, catalina:       "d8a2a60e05f91d573d79873aa63b07333fcdb4e0aa329edde9541d1371d11eef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e2c4ac79db46bad4ad9e1abbb648347de5433db85151c8114f19774b3c01f0d9"
  end

  uses_from_macos "sqlite" => :test
  uses_from_macos "tcl-tk"

  def install
    tcl = if OS.mac?
      MacOS.sdk_path/"System/Library/Frameworks/Tcl.framework"
    else
      Formula["tcl-tk"].opt_lib
    end

    system "./configure", "--disable-debug",
                          "--with-tcl=#{tcl}",
                          "--prefix=#{prefix}"
    system "make", "sqlite3_analyzer"
    bin.install "sqlite3_analyzer"
  end

  test do
    dbpath = testpath/"school.sqlite"
    sqlpath = testpath/"school.sql"
    sqlpath.write <<~EOS
      create table students (name text, age integer);
      insert into students (name, age) values ('Bob', 14);
      insert into students (name, age) values ('Sue', 12);
      insert into students (name, age) values ('Tim', 13);
    EOS
    system "sqlite3 #{dbpath} < #{sqlpath}"
    system bin/"sqlite3_analyzer", dbpath
  end
end
