class Sqldiff < Formula
  desc "Displays the differences between SQLite databases"
  homepage "https://www.sqlite.org/sqldiff.html"
  url "https://www.sqlite.org/2024/sqlite-src-3450300.zip"
  version "3.45.3"
  sha256 "ec0c959e42cb5f1804135d0555f8ea32be6ff2048eb181bccd367c8f53f185d1"
  license "blessing"

  livecheck do
    formula "sqlite"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "389c634f8c7555d14b918bb8de7d74d8f0015f45d87e30a4b2c34830219a7dd2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0800ee53d1d55f6d439c9cf2f8179480a44df29f158368967f0a2a9a82b5a4ce"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f47e9d63a0f6883e7581baab351fc32dbe311512311182e0bf37d37c683454d7"
    sha256 cellar: :any_skip_relocation, sonoma:         "9853044070e514d5cbde6ddf4e6ee644333e05f767f5a22f080faf5b5bf46859"
    sha256 cellar: :any_skip_relocation, ventura:        "fc5c49210a4e3e508a31796a51937dce6b8dff6217e69c198ed38dff5ec22bff"
    sha256 cellar: :any_skip_relocation, monterey:       "a902f538f27610852960f83c421d841edbd1f5536e3293e81f5de51c9074da92"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "00ad78e4dfd8ddee7781dc35da7a1abcea2caf561003363520fdd5f35a0467c4"
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
