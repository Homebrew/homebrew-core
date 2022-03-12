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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5771f92136920ea8070f4fa309fa39b6b1ce05eefa79bef257d20d72189bb0eb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "babc545e54d00450583087b74553ea9b0d474af20b2605d8e9ff78115e2431fd"
    sha256 cellar: :any_skip_relocation, monterey:       "5b3ec4ff1d74dddc6a217372a3332ac21f9bdc51fc425bea4e92786a9838f1de"
    sha256 cellar: :any_skip_relocation, big_sur:        "8c5753ccb5c35081d6a6d385f421ac6c6ad63a0801db1d6aa28bb2fef674b811"
    sha256 cellar: :any_skip_relocation, catalina:       "7ea52a9a7ac85e52d8bebcdbb0550b4425de61b8ba25e940bb2c211fe13357be"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "109c2229f634d37792af5a98d38e69d96ee220e8b615ee564e26f4bacc85620b"
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
