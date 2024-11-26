class Sqldiff < Formula
  desc "Displays the differences between SQLite databases"
  homepage "https://www.sqlite.org/sqldiff.html"
  url "https://www.sqlite.org/2024/sqlite-src-3470100.zip"
  version "3.47.1"
  sha256 "572457f02b03fea226a6cde5aafd55a0a6737786bcb29e3b85bfb21918b52ce7"
  license "blessing"

  livecheck do
    formula "sqlite"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "79393f26558c7ec1c6c7e6dfa6adcef175e037f70c9e8b59e5d106da45e1f39b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "27a0367c97f5cd7369348c083a18de724e0c1568a5cc88701b4d4223898f4f86"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4e83d8dbcd63aeab1f82dd9beecad5457430cb4b012d3a8d580b8a6d716bdbf3"
    sha256 cellar: :any_skip_relocation, sonoma:        "882b386eaa836c801fa2e21f318f8db71cdbee29d2f58430264cfd0c5055d9b5"
    sha256 cellar: :any_skip_relocation, ventura:       "b5f504420a55d8d4f69ac175f836845cfef42ea3e7a73b4b169d39225521074d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c174686657bf4763e3e24fe859ea9a4629f1fe86273939b39266a804e7f60134"
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
