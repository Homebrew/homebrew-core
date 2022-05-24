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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "40b8a840e794ada0a839e010963adc2f4e7f832990c2c732db7c54e98a16e905"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8000ec3de9f3f050a4a59fbd8daa126cd277af02e67718cf0671fee0bec451b8"
    sha256 cellar: :any_skip_relocation, monterey:       "90155427dcdc7aca2dfe7e31e38ac0a9fbe4f7421e73c197be2b8dd1e3a6d3e5"
    sha256 cellar: :any_skip_relocation, big_sur:        "55f3fc4a4dab67414b0d4b4cd5e14907aedaa4585b8997181097e5fb86e80906"
    sha256 cellar: :any_skip_relocation, catalina:       "6f13d158ccec4800233032be8d8b3a46ad022a7e8bf8f33fd336897677e11109"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "07c6a5a85ee4730d15693d8b821f8a2f0089b10f6d134b7573d80b0b57f76420"
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
