class Sdb < Formula
  desc "Ondisk/memory hashtable based on CDB."
  homepage "https://github.com/radare/sdb"
  head "https://github.com/radare/sdb.git"

  stable do
    url "https://github.com/radare/sdb/archive/0.12.tar.gz"
    sha256 "6f1ea21495f2df1030f56ef3517c907466eb817840d2730d4a5abb8a85096a0d"

    # Remove for > 0.12
    # Avoid "sdbtypes.h: No such file or directory"
    # Reported 12 Sep 2017 https://github.com/radare/sdb/issues/147
    patch do
      url "https://github.com/radare/sdb/commit/f824720.patch?full_index=1"
      sha256 "23ad3e130e40ca078a488103d510062fe5bcadf844e01b3ac03c0dd50133f16b"
    end
  end

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
