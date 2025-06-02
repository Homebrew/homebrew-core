class Sqldiff < Formula
  desc "Displays the differences between SQLite databases"
  homepage "https://www.sqlite.org/sqldiff.html"
  url "https://www.sqlite.org/2025/sqlite-src-3500000.zip"
  version "3.50.0"
  sha256 "af673f28f69b572b49bb1558c4f191fd66e31acb949468ad2b01b2b6ed8043a2"
  license "blessing"

  livecheck do
    formula "sqlite"
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "96cc2fa6bfb0641869b1b283cead6fc9f3a762a2fca445c03bd152128e1b0bc2"
    sha256 cellar: :any,                 arm64_sonoma:  "c5528848518b11ca376a3ef8ece699841a0224129c55c639abe627252685d282"
    sha256 cellar: :any,                 arm64_ventura: "927b9690ffba78f8bd451d7e21c5363bf1560cecd94b357c67446e1dba1d26ae"
    sha256 cellar: :any,                 sequoia:       "0bec7d8a4f5c0c3e30c2ed80d8fb446e99a3a6e6a44f7340848f9adefaa7dd17"
    sha256 cellar: :any,                 sonoma:        "895af9dfa940fe5095a1108ee1997978affa43bb560a77a098951d91efc66314"
    sha256 cellar: :any,                 ventura:       "a1bc3eb3521b58f42009fea2963145c8e886d1943e64759e37b380bcc316e061"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "32afc1e73b7c45e58383d43c55838066b16b6bde13661a76961ee974c98855c8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "33efd819fd4d75f54706965617a2db25dba6d7d025b0209c394cf9c0adca8196"
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
