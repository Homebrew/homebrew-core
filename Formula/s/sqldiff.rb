class Sqldiff < Formula
  desc "Displays the differences between SQLite databases"
  homepage "https://www.sqlite.org/sqldiff.html"
  url "https://sqlite.org/2026/sqlite-src-3510200.zip"
  version "3.51.2"
  sha256 "85110f762d5079414d99dd5d7917bc3ff7e05876e6ccbd13d8496a3817f20829"
  license "blessing"

  livecheck do
    formula "sqlite"
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "a403f5df2b55ede4c68c2f2875cf7bc4d891137cd2bad744cf34994758d23314"
    sha256 cellar: :any,                 arm64_sequoia: "3d8153c5203a7c7415ed7bec58f1208a9bd93afef3703dbb3cdfe644b911ed34"
    sha256 cellar: :any,                 arm64_sonoma:  "c344234fbe6c50f4e9fa774479b05f7a8b80ca458cd52f27f88f448784b11672"
    sha256 cellar: :any,                 tahoe:         "e2e142266571dd13804f99e61ce25a17f8403b8710b168b340f76b8c436e7bec"
    sha256 cellar: :any,                 sequoia:       "91d7e0b920e019425754155d3bb6d30ebe1275f52f0ae4d555cabbf406799884"
    sha256 cellar: :any,                 sonoma:        "55206b74b6420f74d196eaf931ea578d760802ec5c1b217d89b637500637e50e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "40f9cbd0c8e7282d31e9e1b8a60753f0f46b700a55529ec7c0959931c84ad646"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c032c509444e725199c9199a703ea20f864dfab2e7cbdb16d1c070a21f21bcdd"
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
