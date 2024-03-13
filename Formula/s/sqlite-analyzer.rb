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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0d943aea8a7a13b1f1e128ae81378281734983cdc5b3c1492dcb3c2993958625"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7ff57a396a5f9627fc914bff7ae1b8482c5351e711061923650d9fc77ce4db44"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "605f45110f7a9259adaf3fb99679f7b08db7ee3adcb6394b9094ba2f278d36c3"
    sha256 cellar: :any_skip_relocation, sonoma:         "93f91740e4a8fa2864b527626ca91c800cc6875c86ea49032246d805fa3cba86"
    sha256 cellar: :any_skip_relocation, ventura:        "8c5234a2ac236ae8895836d48c528f1dd9b5e49834db447fbaa5da0df849c8f1"
    sha256 cellar: :any_skip_relocation, monterey:       "c9e09006a9b27994ef2346828d5761f0345d146fed7e89c42398fc692083f89b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "924ed707565f79e5ec5c7358e6761862c736f39e0bb5c870e41ae99a538bdbdf"
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
