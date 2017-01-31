class Sdb < Formula
  desc "Ondisk/memory hashtable based on CDB."
  homepage "https://github.com/radare/sdb"
  url "http://www.radare.org/get/sdb-0.10.5.tar.gz"
  sha256 "9eae3ed9e5a889e22395333d2c3503230a6418caad3e7739b918ea37315a87bf"

  bottle do
    cellar :any
    sha256 "0a5172a862a6e5c528caf30a40274c7435d12dc8fada163eb8a6727c5c0a2515" => :sierra
    sha256 "ce33a994e6804e6159104318614c3b5c02a7abdb6d6c6422e9a031a41f7e896f" => :el_capitan
    sha256 "49d380c751c0e65776961446ab788e544bcbbcd765674773c09426cec0dc440a" => :yosemite
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
