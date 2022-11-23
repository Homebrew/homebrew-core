class Sqldiff < Formula
  desc "Displays the differences between SQLite databases"
  homepage "https://www.sqlite.org/sqldiff.html"
  url "https://sqlite.org/2022/sqlite-src-3400000.zip"
  version "3.40.0"
  sha256 "48550828142051293e179ffc6a8520f6fbfd82e1cdca78b93792f766cc89b8e2"
  license "blessing"

  livecheck do
    formula "sqlite"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b5d77ed53e2906ef7254c8c4e44aa9628030ee2e3155494f3956499de67ea1c8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a8a3baac89dd382ed5c732476c40bc0e3340d25773e450fd6a30131d2b84f488"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fc193af281b4e26b15084c8729acfcb9b01c09dd0b0048c827fbcddb570c93f1"
    sha256 cellar: :any_skip_relocation, monterey:       "b8e5e78522ae98fd60b5f21e2713ab20e0b8929286a5ef7e9000964494aa0edc"
    sha256 cellar: :any_skip_relocation, big_sur:        "3a9c268aeef0baba12616d0f9e890d2fa1db947306ecdeb2ca1bfa5ac442d795"
    sha256 cellar: :any_skip_relocation, catalina:       "e59807b98af44caa7ab68859de34a3289aaaef07729f8af5f0982d5c9ae65419"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "975636aaeb22957b1b04203a86cb03e71c06ca083a926193da504f66ae7747b9"
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
