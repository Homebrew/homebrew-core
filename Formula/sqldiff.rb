class Sqldiff < Formula
  desc "Displays the differences between SQLite databases"
  homepage "https://www.sqlite.org/sqldiff.html"
  url "https://sqlite.org/2022/sqlite-src-3380100.zip"
  version "3.38.1"
  sha256 "177aefda817fa9f52825e1748587f7c27a9b5e6b53a481cd43461f2746d931d8"
  license "blessing"

  livecheck do
    formula "sqlite"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d49da5c5148dd0f8100687c2cf3f2ae42e156261c356875d90f5a734ff8d5c30"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d01be45577b8e7f828e69382c886197de5e55a40503053ca24a041bad466acbf"
    sha256 cellar: :any_skip_relocation, monterey:       "a23792a5a48e0ab05d378ff1606977a35b27a284943a243a59ca86666bd38f2d"
    sha256 cellar: :any_skip_relocation, big_sur:        "334531ba3d5bb8e4877b09b9be0e5d52648deb2fc0d6b508e14f45068cfb3584"
    sha256 cellar: :any_skip_relocation, catalina:       "187b0b2918b7c85783d0dd203b5c9db05f4dcd42fa5f8ab216d390af6684eda8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5ce45ed74126131e1a4d020b3d8a24b8887daee54c8c0895134062eb197166ce"
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
