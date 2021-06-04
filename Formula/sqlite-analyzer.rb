class SqliteAnalyzer < Formula
  desc "Analyze how space is allocated inside an SQLite file"
  homepage "https://www.sqlite.org/"
  url "https://www.sqlite.org/2021/sqlite-src-3350500.zip"
  version "3.35.5"
  sha256 "f4beeca5595c33ab5031a920d9c9fd65fe693bad2b16320c3a6a6950e66d3b11"
  license "blessing"

  livecheck do
    url "https://sqlite.org/news.html"
    regex(%r{v?(\d+(?:\.\d+)+)</h3>}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "68d606f32f8e9be763205d626183adacc7433cd813685026e699ca959ac3fd3f"
    sha256 cellar: :any_skip_relocation, big_sur:       "a925170b6af69075264632f89db74e7e4918b665f450d7ccbf79eb9d61e63394"
    sha256 cellar: :any_skip_relocation, catalina:      "0e36e1df08ddaf434bf3f3e70ed11a10241032de1337305dc71f109dfa1f2377"
    sha256 cellar: :any_skip_relocation, mojave:        "ff5a6654f1c12c6bb5b9c33bcf9f91c262a4434e3a4436ce77058c7a1c3cec88"
  end

  def install
    sdkprefix = MacOS.sdk_path_if_needed
    system "./configure", "--disable-debug",
                          "--with-tcl=#{sdkprefix}/System/Library/Frameworks/Tcl.framework/",
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
    system "/usr/bin/sqlite3 #{dbpath} < #{sqlpath}"
    system bin/"sqlite3_analyzer", dbpath
  end
end
