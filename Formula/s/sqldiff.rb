class Sqldiff < Formula
  desc "Displays the differences between SQLite databases"
  homepage "https://www.sqlite.org/sqldiff.html"
  url "https://www.sqlite.org/2024/sqlite-src-3460100.zip"
  version "3.46.1"
  sha256 "def3fc292eb9ecc444f6c1950e5c79d8462ed5e7b3d605fd6152d145e1d5abb4"
  license "blessing"

  livecheck do
    formula "sqlite"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "eeb064d21561e2d1ea6668cd858cd2be7a34f786f3b98e02e7e26d9dc89864a0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4e0ffa19e5ec6cd94d2676b208251c4a986c13a67710243d58eb4f918f6aa754"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "30904d9dac7c8ce943d58af4d5b63c1ef9ab6b69e9f0e9b4733c72ff2a363884"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "79c3211ff55206f25b1212011936e961e0e7a724c6e2076a98327d4bf7d64066"
    sha256 cellar: :any_skip_relocation, sonoma:         "9387763132d94de45a90e55cb17182d4adc81f1efa327f02b46f5319a5ec03fc"
    sha256 cellar: :any_skip_relocation, ventura:        "4cd4123b73e3457580fe9151c3f144c531f7c5f681551840d7d03d4d7901c438"
    sha256 cellar: :any_skip_relocation, monterey:       "41d07fa8aaa4d3604497594a18f151e1a47973553b2e8dc003bfa4fbbff963f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5cc411d974c0af4d83d092e5395e5c3d0523f376108964eb2b0dd8c20ed488b0"
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
