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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "52220d0b6f1ddd14637b7cb56736421234e2a9cb6621f62fe049e362c7a5a4e7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7a49322029ea4052f821967f2e3c6b886c88a22f27dc2ffd92aaf6a613eddf18"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "edd8f2a17ff75d1c72ba4f6e246a448eb4b96bc1342178dc27fe17683a6228ea"
    sha256 cellar: :any_skip_relocation, sonoma:        "a26a443de2daa8ff777f05661d8f98738f2e17f34ed7325e1f4751088c70a13e"
    sha256 cellar: :any_skip_relocation, ventura:       "454b0f61c466a65a6a9232028c46612d87be30a263c35332c975528a17e015f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c50ecfee6225abb5fe56fde310cb500015b3ead9f6baabbd7badda0cbe0c6e9c"
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
