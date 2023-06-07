class Sqldiff < Formula
  desc "Displays the differences between SQLite databases"
  homepage "https://www.sqlite.org/sqldiff.html"
  url "https://www.sqlite.org/2023/sqlite-src-3420000.zip"
  version "3.42.0"
  sha256 "38ca56a317be37fb00bd92bc280d9b9209bd4008b297d483c41ec1f6079bfb6d"
  license "blessing"

  livecheck do
    formula "sqlite"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e77cf1c3b7494e7453918b4c2b80ef93b3fdc07a34f9604489d8afd311c43111"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "97ac7bcdbde502a48e6715564b22277ed628ed04964c9b365255818d0b9babcf"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b8dd59b40a8592fce276005b534ac8e8a9c951f8db1ef279001dda839c5a7851"
    sha256 cellar: :any_skip_relocation, ventura:        "fa978652a8b4d6bd62b35ccab977a2f191bea8e4055a638014eed598eb762ebe"
    sha256 cellar: :any_skip_relocation, monterey:       "8dfddf54fb1d531d4c7b5a53dd3cc034d6eb139b9574ce2394d82b6f38ec53d1"
    sha256 cellar: :any_skip_relocation, big_sur:        "b80fb04865a77ce4295d8e2d7b4a1a9a9f321ad7444919bbe851899db002c412"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1a3a4d57c21c653ff1d4b61ef8afd0f416776c808263917c1d508fe84e8ab0e8"
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
