class Sqldiff < Formula
  desc "Displays the differences between SQLite databases"
  homepage "https://www.sqlite.org/sqldiff.html"
  url "https://sqlite.org/2018/sqlite-src-3250300.zip"
  version "3.25.3"
  sha256 "c7922bc840a799481050ee9a76e679462da131adba1814687f05aa5c93766421"

  bottle do
    cellar :any_skip_relocation
    sha256 "c4434e29c5a8a6b8b4953039e92c477ad694a0f3ab9ec5196a54f75ca12daa36" => :mojave
    sha256 "58e1ae9ac70e649d555482b716d45c46e57c880ef6ed65cad2dd8db62134ea05" => :high_sierra
    sha256 "b3dd8ca907390cd8a9cebacfa657b020f6aca81260a9d918e81fc8131fb77d41" => :sierra
  end

  def install
    system "./configure", "--disable-debug", "--prefix=#{prefix}"
    system "make", "sqldiff"
    bin.install "sqldiff"
  end

  test do
    dbpath = testpath/"test.sqlite"
    sqlpath = testpath/"test.sql"
    sqlpath.write "create table test (name text);"
    system "/usr/bin/sqlite3 #{dbpath} < #{sqlpath}"
    assert_equal "test: 0 changes, 0 inserts, 0 deletes, 0 unchanged",
                 shell_output("#{bin}/sqldiff --summary #{dbpath} #{dbpath}").strip
  end
end
