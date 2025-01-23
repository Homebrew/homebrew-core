class Sqldiff < Formula
  desc "Displays the differences between SQLite databases"
  homepage "https://www.sqlite.org/sqldiff.html"
  url "https://www.sqlite.org/2025/sqlite-src-3480000.zip"
  version "3.48.0"
  sha256 "2d7b032b6fdfe8c442aa809f850687a81d06381deecd7be3312601d28612e640"
  license "blessing"

  livecheck do
    formula "sqlite"
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "0ecda0b930b5df9dc05978938e737f3482831e48f521cc52066ea38de8e24cce"
    sha256 cellar: :any,                 arm64_sonoma:  "18a0cd9babd41f0c0a85935edf009bfc099b10d4f18385137d95b3f9e87aeb91"
    sha256 cellar: :any,                 arm64_ventura: "977bc361cb997e6418ebf73fac767380d5b5b435273fd95753fa5846ad1cfd35"
    sha256 cellar: :any,                 sonoma:        "c5684b791ac3350583e6487622f928d19d1dcae002871ece5155b42b02fd4245"
    sha256 cellar: :any,                 ventura:       "6e8e03e698bee7c3489fcc95c7bad11b58eedc4181956310442d135cb4b19b9a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bf9cf6e7e5e9cfcc1da3051748005b6601de5bb28211e5f109f41ca66e79f5c7"
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
