class SqliteAnalyzer < Formula
  desc "Analyze how space is allocated inside an SQLite file"
  homepage "https://www.sqlite.org/"
  url "https://www.sqlite.org/2023/sqlite-src-3410100.zip"
  version "3.41.1"
  sha256 "db929012f9009e7f07960e7f017e832d8789a29f4b203071b4fd79229e7d7a20"
  license "blessing"

  livecheck do
    formula "sqlite"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "598304d585af9e3fefcdafafa5baaced9f7c05c6208e0b92430f8e0914f49bd4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f2199f10448b3a44556677a8f2d5b5e58f9087a096514e7e01c80684875d4e98"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6b5252a0809c11444d94476a0d863d1a111c77a4ee7816cb7b12c68f49d0f9fc"
    sha256 cellar: :any_skip_relocation, ventura:        "909eb10e92a046509085f4f672c22bbda85fad665a5c68b5a90165360365db48"
    sha256 cellar: :any_skip_relocation, monterey:       "fd991f659556c274972342d29b61ea4e29edb62431f1a7d807155b584cdd4eb5"
    sha256 cellar: :any_skip_relocation, big_sur:        "2194a28fbdcc55f5821dea789eb31d5b14cc7b88f49c2fac3a8b3455581506a5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1d1e68c10136a2b596f138c4c0f8b854ce506e72c8ac17d8e50ba54c0e89f066"
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
