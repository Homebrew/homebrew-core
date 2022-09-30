class Sqldiff < Formula
  desc "Displays the differences between SQLite databases"
  homepage "https://www.sqlite.org/sqldiff.html"
  url "https://sqlite.org/2022/sqlite-src-3390400.zip"
  version "3.39.4"
  sha256 "02d96c6ccf811ab9b63919ef717f7e52a450c420e06bd129fb483cd70c3b3bba"
  license "blessing"

  livecheck do
    formula "sqlite"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fe912f11681cd82be066c87af09ce8d989fee4f310a2ad63ddbccb7dc0c9deda"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1e0a9ae6bebf27816a32daeaa7520a1a1944f63626dc799cec6e280e7d9f0f7e"
    sha256 cellar: :any_skip_relocation, monterey:       "1530cdbe579eb6cf5eec1b366a0ec351e12b6764bffe6a8bd72f405529869b32"
    sha256 cellar: :any_skip_relocation, big_sur:        "e8a16a5c71bdc9561035509afd37bdb8e7066edb69d83de1c576ee47a2fd0923"
    sha256 cellar: :any_skip_relocation, catalina:       "ce48ebb66d60afe973bc2103521b2f1ed69af0218dfef0b1b6b9998ccadd9c1f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1629bebfa819c859e6950f1e7fe72d082b8ebcaff3d0f2942564d51e71ac718c"
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
