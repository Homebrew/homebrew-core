class SqliteAnalyzer < Formula
  desc "Analyze how space is allocated inside an SQLite file"
  homepage "https://www.sqlite.org/"
  url "https://sqlite.org/2022/sqlite-src-3380500.zip"
  version "3.38.5"
  sha256 "6503bb59e39ec8663083696940ec818cd5555196e6ca543d4029440cca7b00d9"
  license "blessing"

  livecheck do
    formula "sqlite"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "588abf1d5b2c3e2862ba8dff7f03833c516434c22484b5ce99294ce64116763a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4513640947e3bc6dfb585f3492748b53f65940b3f48179470b94026065c9f451"
    sha256 cellar: :any_skip_relocation, monterey:       "c82745bda6a9417af74f95d40b1c6f99a2b98907daee8a965db2888b0ed147c1"
    sha256 cellar: :any_skip_relocation, big_sur:        "d5d309a56971f6d9b94f26d08f735440c8d9d4481345bec00d0dd4d9f0af52e3"
    sha256 cellar: :any_skip_relocation, catalina:       "b04e668dd6f395c939def39f9ff45195d1d65b302b1f9ba6287612d1ade0724e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "102e92f069fcf4c9e7be4cebc3c2cf43601e191f62be229e3345c6461a793766"
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
