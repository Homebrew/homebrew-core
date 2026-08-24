class SqliteRsync < Formula
  desc "SQLite remote copy tool"
  homepage "https://www.sqlite.org/"
  url "https://www.sqlite.org/2026/sqlite-src-3530400.zip"
  version "3.53.4"
  sha256 "d18fa15aec74d8c17e1463f861095adc01b5ad190256acb4f91d22f0368d232b"
  license "blessing"

  livecheck do
    formula "sqlite"
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256               arm64_tahoe:   "95475d80fb7d218d8995abd79429da23f23dc600aa9ebc786ac5bac9227e70c3"
    sha256               arm64_sequoia: "78950e233fea93ac6e65ff746c1120b9c04fce37e9281b384de119730c0a3106"
    sha256               arm64_sonoma:  "659f6354636097d9bb37ef82cf7405c631be8859b515297b10607986b47eed31"
    sha256 cellar: :any, tahoe:         "5b2fce83520582446cf3849ef7a787f2ca31548f6f378669409cc8a415992380"
    sha256 cellar: :any, sequoia:       "671503f6d3a880ce309529d9034bf3c3b7794a494b316e16cea2d4ccdc607dae"
    sha256 cellar: :any, sonoma:        "082b25dd8e471805552afff546963899a2e21404d3c5a097dada080be18328f4"
    sha256 cellar: :any, arm64_linux:   "06f16a1c2e37ee64a51e799bc1481f1d23b7cd94ca21ae5833e8e631c4ccfc7c"
    sha256 cellar: :any, x86_64_linux:  "3bb40f3474ceaff3f59ba497b3e16f8badf9b3a2ca03c561b4f4d431274d1add"
  end

  uses_from_macos "tcl-tk" => :build
  uses_from_macos "sqlite" => :test

  def install
    tcl = if OS.mac?
      MacOS.sdk_path/"System/Library/Frameworks/Tcl.framework"
    else
      formula_opt_lib("tcl-tk")
    end

    system "./configure", "--disable-debug",
                          "--with-tcl=#{tcl}",
                          "--prefix=#{prefix}"
    system "make", "sqlite3_rsync"
    bin.install "sqlite3_rsync"
  end

  test do
    dbpath = testpath/"school.sqlite"
    copypath = testpath/"school.copy"
    sqlpath = testpath/"school.sql"
    sqlpath.write <<~SQL
      create table students (name text, age integer);
      insert into students (name, age) values ('Bob', 14);
      insert into students (name, age) values ('Sue', 12);
      insert into students (name, age) values ('Tim', 13);
    SQL
    system "sqlite3 #{dbpath} < #{sqlpath}"
    cp dbpath, copypath

    addpath = testpath/"add.sql"
    addpath.write <<~SQL
      insert into students (name, age) values ('Frank', 15);
      insert into students (name, age) values ('Clare', 11);
    SQL
    system "sqlite3 #{dbpath} < #{addpath}"
    system bin/"sqlite3_rsync", dbpath, copypath
    assert_match "Clare", pipe_output("sqlite3 #{copypath}", "select name from students where age = 11")
  end
end
