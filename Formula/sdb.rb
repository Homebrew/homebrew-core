class Sdb < Formula
  desc "Ondisk/memory hashtable based on CDB"
  homepage "https://github.com/radare/sdb"
  url "https://github.com/radareorg/sdb/archive/1.8.4.tar.gz"
  sha256 "496a773fdf85c400f00b9b73bc13e4e6588f9293594e959958a17e9b43961b34"
  license "MIT"
  head "https://github.com/radare/sdb.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "ed54ade000c39bfef143406c05788247863392ec9aecd50a79d5ab9481a06a7b"
    sha256 cellar: :any,                 arm64_big_sur:  "5cef0bdc9c6e5a9f5a3eb1b05d4e07df8cb22bb63c6a6baac9069a7ddd336c42"
    sha256 cellar: :any,                 monterey:       "c2773743db31227bdb3604cb307b83745d0f5d319ca6f4b850c3846d056f7a3a"
    sha256 cellar: :any,                 big_sur:        "16a5644fc9e7993ee6efdac28c26a8768d92f6b14eab8c5acab34527d20fd0eb"
    sha256 cellar: :any,                 catalina:       "9fa03e102442171281fa15710299371c7ef6414b3d54083b60c4a7c461cba6a6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "12baa0b0dfc81229a5edec54dbdfc358ceb2116745f4fe155670ba73c7134e83"
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
