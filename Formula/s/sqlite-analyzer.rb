class SqliteAnalyzer < Formula
  desc "Analyze how space is allocated inside an SQLite file"
  homepage "https://www.sqlite.org/"
  url "https://www.sqlite.org/2025/sqlite-src-3500400.zip"
  version "3.50.4"
  sha256 "b7b4dc060f36053902fb65b344bbbed592e64b2291a26ac06fe77eec097850e9"
  license "blessing"

  livecheck do
    formula "sqlite"
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "119aab9d8965e2bc6a42f0f688d18fc84f884256176a8ad6308096f36e07cadd"
    sha256 cellar: :any,                 arm64_sequoia: "983c929529debfa69afd99dc23a7025dbe681a100fafa0f20c08ef3b144310cb"
    sha256 cellar: :any,                 arm64_sonoma:  "8c6c0770b134f712086b1fc259c469428b2cb214a11737d1ed7b46acec77bbf7"
    sha256 cellar: :any,                 arm64_ventura: "2a4457aa0b6bd51662221422b09993d9a9adf6d8d5d6a8ca8d066820b6734ae1"
    sha256 cellar: :any,                 sonoma:        "9ea7789c685af83f51e33619c920b963605cb39dbbb8f872b135fad0b32122ec"
    sha256 cellar: :any,                 ventura:       "b76902ea0ea66727d276c099b81003714783bf48fa4535cf12bd2200dcca0b5b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ec05b4e264b7c5477bf2daa0f9b860d04548699383f231eef61816472cc937b3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "69276f619b21ed65f21da3db17842b02c0355b0e05a3db2bc8119001cb673122"
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
