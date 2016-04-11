class Sqlcipher < Formula
  desc "SQLite extension providing 256-bit AES encryption"
  homepage "http://sqlcipher.net"
  url "https://github.com/sqlcipher/sqlcipher/archive/v3.4.0.tar.gz"
  sha256 "99b702ecf796de02bf7b7b35de4ceef145f0d62b4467a86707c2d59beea243d0"

  head "https://github.com/sqlcipher/sqlcipher.git"

  bottle do
    cellar :any
    sha256 "66e80714a76b6dc4b05bf282ca65e780baddadb87dd1310980b42fa5d97eeb19" => :el_capitan
    sha256 "7f2abb8d51497f300290c2914b93e1223835022d79a84556ad08a062789492cb" => :yosemite
    sha256 "42b83a8578cd1c5a46c95095a7783ff50a6280b42751f9ae606277f356ba188d" => :mavericks
  end

  option "with-fts", "Build with full-text search enabled"

  depends_on "openssl"

  def install
    args = %W[
      --prefix=#{prefix}
      --enable-tempstore=yes
      --with-crypto-lib=#{Formula["openssl"].opt_prefix}
      --enable-load-extension
      --disable-tcl
    ]

    if build.with?("fts")
      args << "CFLAGS=-DSQLITE_HAS_CODEC -DSQLITE_ENABLE_FTS5"
    else
      args << "CFLAGS=-DSQLITE_HAS_CODEC"
    end

    system "./configure", *args
    system "make"
    system "make", "install"
  end
end
