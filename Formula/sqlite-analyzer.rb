class SqliteAnalyzer < Formula
  desc "Analyze how space is allocated inside an SQLite file"
  homepage "https://www.sqlite.org/"
  url "https://www.sqlite.org/2022/sqlite-src-3370200.zip"
  version "3.37.2"
  sha256 "486770b4d5f88b5bb0dba540dd6ee1763067d7539dfee18a7c66fe9bb03d16d9"
  license "blessing"

  livecheck do
    formula "sqlite"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6e38b7476bda89b16ff0955f35f6e32ad7a15e75af600930338fac32b33aec1f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ca75fb3a2b5c12770d9c706403b007dd6264d687b848d525e27e7b509c587ce0"
    sha256 cellar: :any_skip_relocation, monterey:       "8c5f513b1e09418456d32dc747c3205fbcbbcf6bdd77cf7aae6bbd22097ad0dc"
    sha256 cellar: :any_skip_relocation, big_sur:        "a983b13a3ebd77926930ba47ff66b7baf49e6866e60f6905ad8282ce27b19b01"
    sha256 cellar: :any_skip_relocation, catalina:       "92cfddfc8777e0c91e6c8546a5b9f63022d324da8d9f0d092077e7161b303a59"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "30feeeb98e952dbb78e3de149db8372309fa71e67048e41de2a2ac97899d2afe"
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
