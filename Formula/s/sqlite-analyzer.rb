class SqliteAnalyzer < Formula
  desc "Analyze how space is allocated inside an SQLite file"
  homepage "https://www.sqlite.org/"
  url "https://www.sqlite.org/2023/sqlite-src-3430200.zip"
  version "3.43.2"
  sha256 "eb6651523f57a5c70f242fc16bc416b81ed02d592639bfb7e099f201e2f9a2d3"
  license "blessing"

  livecheck do
    formula "sqlite"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "74dbd5e93bfa2b9460ce100ef61fba2d3ae92c3ee12154ee42a467ed496ec013"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2bf87254682b905ac0367663c9044d373c3207703b60930c78a37d931ef20b30"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "adaac381dc7e4ec1e406a651fb5832580cc4b19101eb74823ea18f00a7c0b7fa"
    sha256 cellar: :any_skip_relocation, sonoma:         "a682e50c8863592226f9e5b6e9c0569204cb476407756e6227e7dc554e562d49"
    sha256 cellar: :any_skip_relocation, ventura:        "78b2d08593d441f79cc85d14f427a133a436d9573df509e6d6df8562f686e138"
    sha256 cellar: :any_skip_relocation, monterey:       "7fdd38920ba87b3f652c48aa4ac3f05c37df347c59fc7ab1865bb405ef951950"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b2b36454c7900450221515371640dc1d13c8f2b5411fea2cf9f083082705febe"
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
