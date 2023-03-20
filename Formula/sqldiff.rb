class Sqldiff < Formula
  desc "Displays the differences between SQLite databases"
  homepage "https://www.sqlite.org/sqldiff.html"
  url "https://www.sqlite.org/2023/sqlite-src-3410100.zip"
  version "3.41.1"
  sha256 "db929012f9009e7f07960e7f017e832d8789a29f4b203071b4fd79229e7d7a20"
  license "blessing"

  livecheck do
    formula "sqlite"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f650b073ed29e9ef27c02083ab2f9a86101c0de62e686a47101af82439d6b108"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fd47cb4e83254e4bda16cafdf4d46c64a61bf648abf28a3774e69697264d9ef2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "80a81e811f6e23205a5b674290c701e2209384211ba3d13e100ff2265be868da"
    sha256 cellar: :any_skip_relocation, ventura:        "fe09be94cee49aaa43673ab3c3ca3a45fee338136d53cada23f5b191b733b460"
    sha256 cellar: :any_skip_relocation, monterey:       "828de1ef60966335b8643e5686c5154cf06d1d52b6c64db4c95e45f9d9617d8e"
    sha256 cellar: :any_skip_relocation, big_sur:        "aeb1112e0933ea3385dc99db52fbe5534397ffa7b8dd1113006912c037b21295"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0df68252d475a8f673849980f126dfc07a16ede0dfd731dbf8317e849a307b04"
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
