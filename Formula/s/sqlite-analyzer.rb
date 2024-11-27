class SqliteAnalyzer < Formula
  desc "Analyze how space is allocated inside an SQLite file"
  homepage "https://www.sqlite.org/"
  url "https://www.sqlite.org/2024/sqlite-src-3470000.zip"
  version "3.47.0"
  sha256 "f59c349bedb470203586a6b6d10adb35f2afefa49f91e55a672a36a09a8fedf7"
  license "blessing"
  revision 1

  livecheck do
    formula "sqlite"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5b3aa0bf93eb73cf44225ee62249d98fec811922c437b1c3a4675972d0b551fe"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a9fbc0d5b1ca41f58692ff030acaa34b445c1b89f8814725086c69f025ab8acb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2843a46bbbb8e9c143da7bfdc0fd0936b19ab11c8d9a5c559ba9eb8bdb6232a7"
    sha256 cellar: :any_skip_relocation, sonoma:        "680620cf792d74d6146ae1c11d275a6df42e4f91596984023a9b98913b50918f"
    sha256 cellar: :any_skip_relocation, ventura:       "9527def8c37e4524b7a9d70c242ae45febfd0481b9125fe561c2123b747574ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ac900124930964af857a3437e24ce3627d5b44d66b4b20967d79b48132769c50"
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
