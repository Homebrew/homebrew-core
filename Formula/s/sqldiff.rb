class Sqldiff < Formula
  desc "Displays the differences between SQLite databases"
  homepage "https://www.sqlite.org/sqldiff.html"
  url "https://www.sqlite.org/2024/sqlite-src-3470000.zip"
  version "3.47.0"
  sha256 "f59c349bedb470203586a6b6d10adb35f2afefa49f91e55a672a36a09a8fedf7"
  license "blessing"

  livecheck do
    formula "sqlite"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e3ab9bb517ae45f4b115caa315e2bff7cf2cff9c609b9cd3322e1ef188b04b31"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "74f0a9a58d3d3a7715f8b400c32c96433d438d49ccc361ce454c10f3dec5a37f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a3e1909c832d5f799d1faf526080c687829e726d90372ca88c31b7880f928e16"
    sha256 cellar: :any_skip_relocation, sonoma:        "d86b6b9916c173677b53866828514e87d1b88681dfdbdb8eb0585a8671c4f603"
    sha256 cellar: :any_skip_relocation, ventura:       "ba0dac5874eb2865d24e89c71865f3d73e76bc75fd9f9b1c03ea0bcff78a4810"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cdb238fde93c6da8491efe73e278c7c8705dfb5ab5b8355430ed2145eaf8b042"
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
