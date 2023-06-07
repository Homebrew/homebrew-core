class SqliteAnalyzer < Formula
  desc "Analyze how space is allocated inside an SQLite file"
  homepage "https://www.sqlite.org/"
  url "https://www.sqlite.org/2023/sqlite-src-3420000.zip"
  version "3.42.0"
  sha256 "38ca56a317be37fb00bd92bc280d9b9209bd4008b297d483c41ec1f6079bfb6d"
  license "blessing"

  livecheck do
    formula "sqlite"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6bb3dca036bbb93c2b0a18b5a697975ce0d8bda10ec0be136786bcfc88ca07ff"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1e2eb16e2a4c5092535ea95fde2ee43a802dd31635588d9ac8940dfc915636a4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b95d6243385ada35e1ece6b38bf1a3ebb087606ddeb4e5194f93c8f4d3d50715"
    sha256 cellar: :any_skip_relocation, ventura:        "2c85fe7bd8be040e1009acaeaec2fb1745968f1686be6a6b1fb08a04f4aefe69"
    sha256 cellar: :any_skip_relocation, monterey:       "6a0a94ac8a14775b4d60016677e01fb8e4b1e223f4b22ce87198b9913fef88b5"
    sha256 cellar: :any_skip_relocation, big_sur:        "74035031e9534de57b35bd29196624f0743a56c267be521fe7953182739e8ed7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2402e914ff6184b6013f07025fa8fa870b45d90c5536c15e734aa3271255b3ed"
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
