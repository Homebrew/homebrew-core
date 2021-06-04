class Sqldiff < Formula
  desc "Displays the differences between SQLite databases"
  homepage "https://www.sqlite.org/sqldiff.html"
  url "https://www.sqlite.org/2021/sqlite-src-3350500.zip"
  version "3.35.5"
  sha256 "f4beeca5595c33ab5031a920d9c9fd65fe693bad2b16320c3a6a6950e66d3b11"
  license "blessing"

  livecheck do
    url "https://sqlite.org/news.html"
    regex(%r{v?(\d+(?:\.\d+)+)</h3>}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "9839317031b372febeb9f1f48546c14e8918ea3a6cafb36b9e60dd2adc8933a6"
    sha256 cellar: :any_skip_relocation, big_sur:       "5ae74319dff30a9ebfa0a8b7a55ccab35f3b290044aba4d657a4f7658ff55f4f"
    sha256 cellar: :any_skip_relocation, catalina:      "aa2b5f08da7c7462aa60215c0e6867946f1e13fe6684e85a7c7d1661f2e19f25"
    sha256 cellar: :any_skip_relocation, mojave:        "363db854250812775c4ff18cfca92a1cd274a263268bdfcd461dd9812f1d0708"
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
