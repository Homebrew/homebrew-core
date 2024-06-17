class Sqldiff < Formula
  desc "Displays the differences between SQLite databases"
  homepage "https://www.sqlite.org/sqldiff.html"
  url "https://www.sqlite.org/2024/sqlite-src-3460000.zip"
  version "3.46.0"
  sha256 "070362109beb6899f65797571b98b8824c8f437f5b2926f88ee068d98ef368ec"
  license "blessing"

  livecheck do
    formula "sqlite"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f85f3573eb9a42ae2ef46baa82cfae465cad59da234e11bf021945369fbbe73b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "734c0b8b68fb922105fb8681d543902843e924082559ec9037761e5bf2795e2d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "55e11aa18bd710dd903c31834d32a09374186ce265c556a3194656299cde99f3"
    sha256 cellar: :any_skip_relocation, sonoma:         "b2ad63f617ff9c9e4c7769bdb9b665d32b6f370605e0d4b686a97ccaf246d77c"
    sha256 cellar: :any_skip_relocation, ventura:        "a8c055e97c5fa76d97e730fa0bf8e512a9b59276f78374969f7fe907e7f58491"
    sha256 cellar: :any_skip_relocation, monterey:       "e76d92ff8df5a9d092b586dea62f05785e678e42043d69d0133a1f957efe7679"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9038d9399f1791399af4f513e2e23a40942fa7420380ebefc1a29455568782c4"
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
