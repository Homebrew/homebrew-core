class SqliteAnalyzer < Formula
  desc "Analyze how space is allocated inside an SQLite file"
  homepage "https://www.sqlite.org/"
  url "https://www.sqlite.org/2023/sqlite-src-3410000.zip"
  version "3.41.0"
  sha256 "64a7638a35e86b991f0c15ae8e2830063b694b28068b8f7595358e3205a9eb66"
  license "blessing"

  livecheck do
    formula "sqlite"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8b7cb5094d830ccccccc999890416b0ae3d8feadcd4ba5dbe4cc9edbc2820f97"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c9f4f88ac920bdb4703afecb76874b8bac68f680dc977bbc49f15ad7acaacfc6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ebd5e892884900db4948be4e027ffdcb8f6e703653ecc90ffb166eba0e7aa2cf"
    sha256 cellar: :any_skip_relocation, ventura:        "3a3e76c102d9ebffff811ccc4a5e6ca30cbfc4a65c1475ab79336cb8b9da03cf"
    sha256 cellar: :any_skip_relocation, monterey:       "80717fc7a50ba1b055af88d94b1edfda5628bb2d832d9c34987f4b8405241707"
    sha256 cellar: :any_skip_relocation, big_sur:        "d1b57d7c71a2147ac7465aad0ba47fa796007be86ff24d575040f65ec3d72396"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aa941dc512a3a21c2f6e651d6a7637b44c90e2b20e789821e8ad4247e1a438b8"
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
