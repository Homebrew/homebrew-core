class SqliteAnalyzer < Formula
  desc "Analyze how space is allocated inside an SQLite file"
  homepage "https://www.sqlite.org/"
  url "https://www.sqlite.org/2024/sqlite-src-3460100.zip"
  version "3.46.1"
  sha256 "def3fc292eb9ecc444f6c1950e5c79d8462ed5e7b3d605fd6152d145e1d5abb4"
  license "blessing"

  livecheck do
    formula "sqlite"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "0d7e6989618d698199c326ae533437c4e555cbf8554b58ea2f44e1f9f055df71"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c7ce6728deffcb45dea25ba6921622ccde1d1ab4bf4bb1bc51ee60a7006732cb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b00a5bafcfa9c81567fec9e2007f85b55ca580f5caaf59a00c20288550620c88"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e31e40ffd4812d5137099279bc29c74d14f15c30d3e1c765b25aa4513424d31a"
    sha256 cellar: :any_skip_relocation, sonoma:         "a7ee7b8a0d9967a8a0bf002f29ef188e3d577f91edbde418b3077cd94170b68a"
    sha256 cellar: :any_skip_relocation, ventura:        "140b7f60ab6ac6637d84c5a3571ba8f7b561352205b280ba8ebea9eef30248d3"
    sha256 cellar: :any_skip_relocation, monterey:       "3f9b5c2acd7ecc8617d3e072f444ba38eebf907e28bfdb0e29c78a11b75ab61f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c359a37822510fec0e67c9c909c7bffd9c2632c783cfd505f73050f40a5dd199"
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
