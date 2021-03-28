class Sqldiff < Formula
  desc "Displays the differences between SQLite databases"
  homepage "https://www.sqlite.org/sqldiff.html"
  url "https://sqlite.org/2021/sqlite-src-3350300.zip"
  version "3.35.3"
  sha256 "4ca1dff5578b1720061dd4452f91a5c3eced5ba3773354291d9aee9e2796a720"
  license "blessing"

  livecheck do
    url "https://sqlite.org/news.html"
    regex(%r{v?(\d+(?:\.\d+)+)</h3>}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "d22e2cf46795c3d2aedb8642872654785a6d4ec5821d64afec135e2709eb33c2"
    sha256 cellar: :any_skip_relocation, big_sur:       "d30fa8ad97b1ca4bdfc6467cdc111ff02dc8c2741e887e9f52beaefc28c05503"
    sha256 cellar: :any_skip_relocation, catalina:      "15fc4fb8ae26ea6c8147870c8991822bcc8382388ad9619aee66c0e026e33bc0"
    sha256 cellar: :any_skip_relocation, mojave:        "345f5db0eed6d366c52778f5aa373e3c1fcc03ca7244ba2ba09cbb1d63da3ccf"
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
    system "/usr/bin/sqlite3 #{dbpath} < #{sqlpath}"
    assert_equal "test: 0 changes, 0 inserts, 0 deletes, 0 unchanged",
                 shell_output("#{bin}/sqldiff --summary #{dbpath} #{dbpath}").strip
  end
end
