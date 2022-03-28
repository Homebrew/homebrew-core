class Sqldiff < Formula
  desc "Displays the differences between SQLite databases"
  homepage "https://www.sqlite.org/sqldiff.html"
  url "https://sqlite.org/2022/sqlite-src-3380200.zip"
  version "3.38.2"
  sha256 "c7c0f070a338c92eb08805905c05f254fa46d1c4dda3548a02474f6fb567329a"
  license "blessing"

  livecheck do
    formula "sqlite"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e3213520bb1e4ace1e6617e8ca065e0b09e403df07b1d85dcbba41c25ea8f31b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6c180e6cfd007d52d836619ba8e4386f63489c66c155f4cd386b24cb8660bfa5"
    sha256 cellar: :any_skip_relocation, monterey:       "12f65bd390e0c9bdc561c3a7722301554f0c231289dd70a2399d080eff3a59c0"
    sha256 cellar: :any_skip_relocation, big_sur:        "a4c1ec033e66e1ff28915c7e3d75d29bd1acbdf239f0ee12442d197e9fcab11b"
    sha256 cellar: :any_skip_relocation, catalina:       "101caafba42333ceef5daaee91c97caf3bf9133247c2724517d35c9d5786febf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1d7c6769db7b3725f1c5cced6e074c8e511b61632727b2122effa64029fa57db"
  end

  uses_from_macos "tcl-tk" => :build
  uses_from_macos "sqlite" => :test

  def install
    system "./configure", "--disable-debug", "--prefix=#{prefix}"
    system "make", "sqldiff"
    bin.install "sqldiff"
  end

  test do
    dbpath = testpath/"test.sqlite"
    sqlpath = testpath/"test.sql"
    sqlpath.write "create table test (name text);"
    system "sqlite3 #{dbpath} < #{sqlpath}"
    assert_equal "test: 0 changes, 0 inserts, 0 deletes, 0 unchanged",
                 shell_output("#{bin}/sqldiff --summary #{dbpath} #{dbpath}").strip
  end
end
