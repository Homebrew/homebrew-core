class Sqldiff < Formula
  desc "Displays the differences between SQLite databases"
  homepage "https://www.sqlite.org/sqldiff.html"
  url "https://sqlite.org/2022/sqlite-src-3390200.zip"
  version "3.39.2"
  sha256 "e933d77000f45f3fbc8605f0050586a3013505a8de9b44032bd00ed72f1586f0"
  license "blessing"

  livecheck do
    formula "sqlite"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "525e79cca706de5abc44d646674ac5ef411e7d2a1101e9dffb41fe22cb72f8c7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "820b505255c69f689a7146a34224ed32f72745f9eba8233bf54723f2fe135cc4"
    sha256 cellar: :any_skip_relocation, monterey:       "895599ff0d986652d0585765fac774ef333df5efb23496909b30cbdc14c1883a"
    sha256 cellar: :any_skip_relocation, big_sur:        "0a09f4c125c5f04873f0d6b567c1f842d4f1194bc4df006aea2079c4485b0716"
    sha256 cellar: :any_skip_relocation, catalina:       "2b6de574b23d4dfe91675a7a43d6ae90e5fc2df0c7c62805f12fc7cbd3172558"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e4b90738d733e34b6406f8e187b2787da91ed460fd4ed7e472cb6463dddfc887"
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
