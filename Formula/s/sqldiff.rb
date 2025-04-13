class Sqldiff < Formula
  desc "Displays the differences between SQLite databases"
  homepage "https://www.sqlite.org/sqldiff.html"
  url "https://www.sqlite.org/2025/sqlite-src-3490100.zip"
  version "3.49.1"
  sha256 "4404d93cbce818b1b98ca7259d0ba9b45db76f2fdd9373e56f2d29b519f4d43b"
  license "blessing"

  livecheck do
    formula "sqlite"
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "8eba0a51124012d7330f891802419b11700906803414b596aae62b3707d87050"
    sha256 cellar: :any,                 arm64_sonoma:  "2c4b335a2e922b87c675dc1cd06d3406bb9ebab2006ad16cac4083c61646f062"
    sha256 cellar: :any,                 arm64_ventura: "14e049ebfabb1d38f1ce2cf960566d284931ad843b7aa774ee6cd269004a313a"
    sha256 cellar: :any,                 sonoma:        "58c04ba1173ef52d826d7c99925cefb26a9312c90604788e46cfbd6186f2516a"
    sha256 cellar: :any,                 ventura:       "2c01bd54ef635172df1530cdacaca3388104c670000cf45e1d4246ecfecf5a54"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f13b0dd26fbb3500e5c847b9813ba246962b96d54863d4b0901b4527bf73e9b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6cf0597f5ff054f828ba8e54b73d2ed6973bb207bbca63bd7b44cb5b0a2a547a"
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
