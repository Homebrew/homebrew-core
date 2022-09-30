class SqliteAnalyzer < Formula
  desc "Analyze how space is allocated inside an SQLite file"
  homepage "https://www.sqlite.org/"
  url "https://sqlite.org/2022/sqlite-src-3390400.zip"
  version "3.39.4"
  sha256 "02d96c6ccf811ab9b63919ef717f7e52a450c420e06bd129fb483cd70c3b3bba"
  license "blessing"

  livecheck do
    formula "sqlite"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "be1db011d42ca9acc9fed096ad3dd66076501374e820417419b0cad75831ae96"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "378db62154507f4ffd830f04a43092ce0eb08a359df1640f3a5f508c1e0631ba"
    sha256 cellar: :any_skip_relocation, monterey:       "6c130469614122aa686882bc53bdcc1a80ba7045e71cf1f68f97316285d83ee2"
    sha256 cellar: :any_skip_relocation, big_sur:        "7fef374f569050dbd4c76f2cb321cfe274a9f94748a21cd7e9ea0dcef8f8328b"
    sha256 cellar: :any_skip_relocation, catalina:       "599881a301e4b82e5efcc99fa3d98e7b5b231f1e7b22d9c6ec4c950824adcd2a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2d6091d69d2b3ff92e3fa4e1fd16772b124b54261d9d6b71ff09d3837a10ec02"
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
