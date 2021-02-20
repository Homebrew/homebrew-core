class Sdb < Formula
  desc "Ondisk/memory hashtable based on CDB"
  homepage "https://github.com/radare/sdb"
  url "https://github.com/radareorg/sdb/archive/1.7.0.tar.gz"
  sha256 "1844caa220c00bd79f5266962767eba85dfa44126d1ec071ffa4007831b82bb8"
  license "MIT"
  head "https://github.com/radare/sdb.git"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "79eeb49fc9a2b7cafc7681b93d4b1cafdbc2c930d79c2131bee4356bac14c9a5"
    sha256 cellar: :any, big_sur:       "38477b9ff223a557af64217d5d331ae60183f0a362b5723f2b818aa42a6c879b"
    sha256 cellar: :any, catalina:      "daa339d2012914fd46fca9a31a4147c1b6aca56716e5d7ad9506be9c2a5f8809"
    sha256 cellar: :any, mojave:        "6fe6e7a17be2d1297726ad76b3a60885211225dc405e13a2206a0d6fc88fc867"
  end

  depends_on "pkg-config" => :build
  depends_on "vala" => :build
  depends_on "glib"

  def install
    system "make"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system bin/"sdb", testpath/"d", "hello=world"
    assert_equal "world", shell_output("#{bin}/sdb #{testpath}/d hello").strip
  end
end
