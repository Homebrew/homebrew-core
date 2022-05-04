class Sqldiff < Formula
  desc "Displays the differences between SQLite databases"
  homepage "https://www.sqlite.org/sqldiff.html"
  url "https://sqlite.org/2022/sqlite-src-3380400.zip"
  version "3.38.4"
  sha256 "ca85ecd10a3970a5f91c032082243081a0aaddc52e6a7f3214f481c69e3039d0"
  license "blessing"

  livecheck do
    formula "sqlite"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "00f948cf2da2f31708151afdc569613c3a3b1584bdb174075b193d03a42cbad5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4469736919506584bb1ac002ae9b81ad5cd972f39470faf499a801bbfb916293"
    sha256 cellar: :any_skip_relocation, monterey:       "6c412c57e0498e3c6465be82d92ad3587c3c4cb1cf9b591025b164df2e046bca"
    sha256 cellar: :any_skip_relocation, big_sur:        "4e11e61a65853512203cbef8ca0fe0fcec71eb9556f477489959602023faace1"
    sha256 cellar: :any_skip_relocation, catalina:       "86b54b541d00937681d701efc7c65000267dfc534c708cf8bf4b9253a03ba599"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b43fd60b0dd0eec10960d6fcfba583045a222426b46ca16bbac882c82923f39e"
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
