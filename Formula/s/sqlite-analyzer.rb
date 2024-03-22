class SqliteAnalyzer < Formula
  desc "Analyze how space is allocated inside an SQLite file"
  homepage "https://www.sqlite.org/"
  url "https://www.sqlite.org/2024/sqlite-src-3450200.zip"
  version "3.45.2"
  sha256 "4a45a3577cc8af683c4bd4c6e81a7c782c5b7d5daa06175ea2cb971ca71691b1"
  license "blessing"

  livecheck do
    formula "sqlite"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "22ad0506a575488cd74978313eeb47de4751d1cca1c88419b8d8c41a574515af"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f68bcd66b6a673137adeb475315bb0463a27f1bafd1ee52744c5fd11098444c0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3903d7b6ee8530dd6c2270f853cdc5dcf434079820c000f2c0400a6c0ab70b4e"
    sha256 cellar: :any_skip_relocation, sonoma:         "434af9fbc9d5419fb8410d1a09146d47a9c107773b92ee74e32e2e2c828a943f"
    sha256 cellar: :any_skip_relocation, ventura:        "43f92a973900e54a73532b3b6bba538a18df55a5a85cac7a09b8f7241bbf9275"
    sha256 cellar: :any_skip_relocation, monterey:       "a8ed13c8c262e51717c7ee67b8fdbefa3630e7e37d226ae275d9682ce1d6d60a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0b1c24bc0499ac5369d5ef4fd4369ae825ac40e6f07ec4d1acae089e762c74ce"
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
