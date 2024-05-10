class SqliteAnalyzer < Formula
  desc "Analyze how space is allocated inside an SQLite file"
  homepage "https://www.sqlite.org/"
  url "https://www.sqlite.org/2024/sqlite-src-3450300.zip"
  version "3.45.3"
  sha256 "ec0c959e42cb5f1804135d0555f8ea32be6ff2048eb181bccd367c8f53f185d1"
  license "blessing"

  livecheck do
    formula "sqlite"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e4935bea02a4cbac1b4de20693fe49ea543f2de7db734ec0272f515a9b6f7909"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2bfae6e1f62f0c15aecbdb9902ebf85affd4081164dcc61703cfed4019daaf72"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e0abc6d1dd3877b4eb72e523ed4376e27e75e1e0ad506e75d894b5696a7f2558"
    sha256 cellar: :any_skip_relocation, sonoma:         "e40d1c643f13459dd150ad252d0b797a5232d6b39da4b4609165d759c3eec66a"
    sha256 cellar: :any_skip_relocation, ventura:        "3ef831f9d5fbaadd99459c8ee4730cdd9513995d48c9c26b0bbdfe40c874a736"
    sha256 cellar: :any_skip_relocation, monterey:       "069db58f7ee3c1535c6506422c12de476d2be364f19ef985a855a01e6e4d5ec2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "552f9de30c1009f69f2be9682a090ab4721265795aee3b77d2c95757af54cf6b"
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
