class Sqldiff < Formula
  desc "Displays the differences between SQLite databases"
  homepage "https://www.sqlite.org/sqldiff.html"
  url "https://www.sqlite.org/2023/sqlite-src-3410100.zip"
  version "3.41.1"
  sha256 "db929012f9009e7f07960e7f017e832d8789a29f4b203071b4fd79229e7d7a20"
  license "blessing"

  livecheck do
    formula "sqlite"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4be49d24faa066dd8ca1c57a2c27907db5071461b10806b1cd67cfc94c0126bc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "93de1557fec36f8a8cfa931802f41ca4e3e4d1bd40eebdff0f9686e40dbc15a0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d01f8a497493e0f95bf603e63af50c54b29f002bc8beba56e419832cd9950ce5"
    sha256 cellar: :any_skip_relocation, ventura:        "99162b133bd1f944722be35de68b7f4c4213a17091012d97219d12156124bad3"
    sha256 cellar: :any_skip_relocation, monterey:       "f80156645306794473c0c84d75bc03d7ee315608186b465ba229ac8a0ca4b484"
    sha256 cellar: :any_skip_relocation, big_sur:        "2e149f3965090cfb4b783eeb92eebee80e699acc3e04d68415cfd823e7e487c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "21cc794150bf56e61f8342fd3cd504a90b580e000d3d4b41e3ef6344d114b514"
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
