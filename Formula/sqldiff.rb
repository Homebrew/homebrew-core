class Sqldiff < Formula
  desc "Displays the differences between SQLite databases"
  homepage "https://www.sqlite.org/sqldiff.html"
  url "https://sqlite.org/2022/sqlite-src-3380500.zip"
  version "3.38.5"
  sha256 "6503bb59e39ec8663083696940ec818cd5555196e6ca543d4029440cca7b00d9"
  license "blessing"

  livecheck do
    formula "sqlite"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d8a963337442bd73b2c7d34f3f974562b09e39b6f3dce93ac35a9a9de689c4f8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c17285849e64578791d64c8ed1c4b586fa76b7a65d6e7112f9326bac364f53d8"
    sha256 cellar: :any_skip_relocation, monterey:       "337fc2e69fc90e487b3a172bc84c943bdd7ef95108bc0e6a7033d165fc2927f4"
    sha256 cellar: :any_skip_relocation, big_sur:        "bf5dd740e03bdfc7fe6324d9f990f4d2370946af7c71ac07fba5a22578849939"
    sha256 cellar: :any_skip_relocation, catalina:       "4f35c4d5a83f937f4cadb4fe264147f988d51bd508408c7790aaa56f1ad4b043"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3a63227321c7bb1350cfe7441b4baec5d6c1f4c1aa3e2754f7f6a5dec7795747"
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
