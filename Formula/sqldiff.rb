class Sqldiff < Formula
  desc "Displays the differences between SQLite databases"
  homepage "https://www.sqlite.org/sqldiff.html"
  url "https://www.sqlite.org/2023/sqlite-src-3410000.zip"
  version "3.41.0"
  sha256 "64a7638a35e86b991f0c15ae8e2830063b694b28068b8f7595358e3205a9eb66"
  license "blessing"

  livecheck do
    formula "sqlite"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "49c0e11428ac55056b1b6faff0fbfe185482032a121c172870aa635db295c331"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ae6926cedc5d9d56906f384eca293e43b3d20f4121899e1f52b30c2b2a63f90a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c594dc32aa5232a03e5649f59c7efaaf56adb69c4e50dac9d7493bdae5c47c0b"
    sha256 cellar: :any_skip_relocation, ventura:        "818771cd8e50848a782f92bdad0bf9d923611991d3289861dd3b57ad21eb88b7"
    sha256 cellar: :any_skip_relocation, monterey:       "d107e0eda0e927828d7a1a1c019f570c5289e3ab12d8ceaf603ef1e2d643c6a2"
    sha256 cellar: :any_skip_relocation, big_sur:        "302ee4ad5d6162ff919d912fe9eeec5b8c0c223258c2195d88f175b3f681fddd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9ce783db555f485620a87f7b1e3d1a197647d81acd393e049700b365849f142f"
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
