class SqliteAnalyzer < Formula
  desc "Analyze how space is allocated inside an SQLite file"
  homepage "https://www.sqlite.org/"
  url "https://www.sqlite.org/2023/sqlite-src-3430100.zip"
  version "3.43.1"
  sha256 "22e9c2ef49fe6f8a2dbc93c4d3dce09c6d6a4f563de52b0a8171ad49a8c72917"
  license "blessing"

  livecheck do
    formula "sqlite"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "275fb9f9a0d78a62fa3846f149f2e5de62e358507576e258aaf896b3c647a3dc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "31cd73e5710e5456fbab29967d11fbebded94453fb7e52bbaa22bf4c7a282fec"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "796e3dd8964818ba453df6f591b37cddf70414c5678258cadf7070f8aa261232"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "17e3827b832c135025a9202aaa8b4d5f7cc19831b9ca27fa26457f6fd41d8fa4"
    sha256 cellar: :any_skip_relocation, sonoma:         "5df841efa0289253c3fd62e7c4a9fe452168cde266c7c1af654299e0d8141785"
    sha256 cellar: :any_skip_relocation, ventura:        "befaa733c2b303671cccaed75b077d04aa1738cc51f2d55bc881c9a378d105ce"
    sha256 cellar: :any_skip_relocation, monterey:       "734f90454eb391d96644ac1cfe887d6b7085501b2c68c52f92fc08ee0fdb3cd2"
    sha256 cellar: :any_skip_relocation, big_sur:        "0615624fb883770a65e62a44d5d2948e263549a5c6383de7be4cb923f6b065a2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "090cf37e754ceb1b19f33165bba37575ec226c8aad61e9b218733b04a223477a"
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
