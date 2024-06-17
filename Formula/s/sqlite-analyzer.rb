class SqliteAnalyzer < Formula
  desc "Analyze how space is allocated inside an SQLite file"
  homepage "https://www.sqlite.org/"
  url "https://www.sqlite.org/2024/sqlite-src-3460000.zip"
  version "3.46.0"
  sha256 "070362109beb6899f65797571b98b8824c8f437f5b2926f88ee068d98ef368ec"
  license "blessing"

  livecheck do
    formula "sqlite"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ee625a40226386a9d5c842ea65493a2b2cf89a37d78b2e2e6f948eb8f4fe43dd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2806f7d53f6469c66b65d057f3847fb89d21f77f9e585ef0ab9e8f88e8aaf06e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "01da2e86082b0955e6ff9e4f0447bad88ed1f4148a0003c50000cfb6dd3ff5ca"
    sha256 cellar: :any_skip_relocation, sonoma:         "65659e6d69443eb5d463cf9dd51d2c8259524c0679aa41d7e610c86ee8c7f9de"
    sha256 cellar: :any_skip_relocation, ventura:        "ac275fbbab6523b44441ad339115a0be84a3ab71bf4b4e5b446017b1f0afdd0d"
    sha256 cellar: :any_skip_relocation, monterey:       "d4f26dead2c224862f4770147f226a076f4d9da3869b49fb153eee732d4f9959"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b94839e7d3d9def1876129b937eb580e27be57cfdbddc0e0be69c2df0afd62ae"
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
