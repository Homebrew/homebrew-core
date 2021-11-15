class Sqldiff < Formula
  desc "Displays the differences between SQLite databases"
  homepage "https://www.sqlite.org/sqldiff.html"
  url "https://www.sqlite.org/2021/sqlite-src-3360000.zip"
  version "3.36.0"
  sha256 "25a3b9d08066b3a9003f06a96b2a8d1348994c29cc912535401154501d875324"
  license "blessing"

  livecheck do
    formula "sqlite"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "65dc31fc680daed8f58e85ba27359b0deca3d306ba44104924a9cdc6d467a87a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "21de15f86c125a02389a2dca0a7d53dc3dd01dddd6bcc38ceb7d322597a093de"
    sha256 cellar: :any_skip_relocation, monterey:       "2b281ba78d18b622ea07ffce9c5712e77b6d0e341850d05b978c18b8afa89b9f"
    sha256 cellar: :any_skip_relocation, big_sur:        "90601ff9aed7b0638b959e765878f42e38430dead627adbb7d6b68530ecb0915"
    sha256 cellar: :any_skip_relocation, catalina:       "8ccda1604107c379c4072127825ac3a1c042ad03ccb8d6f763335403ca01790c"
    sha256 cellar: :any_skip_relocation, mojave:         "470d541de3685a5b7ba46a997e493e6a69faf1ff69d29b15dbbed0c1e10fd166"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5833fb442881f087a91a2546c41fae83c45332c950da6bfc4d72d78e1a8dc78f"
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
