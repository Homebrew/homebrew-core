class SqliteAnalyzer < Formula
  desc "Analyze how space is allocated inside an SQLite file"
  homepage "https://www.sqlite.org/"
  url "https://sqlite.org/2022/sqlite-src-3400000.zip"
  version "3.40.0"
  sha256 "48550828142051293e179ffc6a8520f6fbfd82e1cdca78b93792f766cc89b8e2"
  license "blessing"

  livecheck do
    formula "sqlite"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "080b377b5c49bb607b225ecb20c5cdaee9e1f0d8268c3772e02b47c14f480b79"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d4ed430d65881bb12776cdb6e2806b594dfac9bc96ccbddd898c46813d285a3a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "64312dd4867abbc7213767e87fdfcfdd865eff7268f64e24fa8f9eecb1021347"
    sha256 cellar: :any_skip_relocation, monterey:       "46f7a6ad0b0983e5101be1991208d77eb9e2172950cfbc093e50ecc0a337c939"
    sha256 cellar: :any_skip_relocation, big_sur:        "509430e265814c513346e38a61c6550f6edee3c71566e8cb823fedbc028c4231"
    sha256 cellar: :any_skip_relocation, catalina:       "f45edd9eab9476d4f1b2baa3938795fd831a54582f7eb325a7df5b993e80718d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b1bc4d317ad67818b66f3862b189b7ea033cfca67fe1f0a871f99ab9f94cb64b"
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
