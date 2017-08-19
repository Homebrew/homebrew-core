class Sqlcipher < Formula
  desc "SQLite extension providing 256-bit AES encryption"
  homepage "http://sqlcipher.net"
  url "https://github.com/sqlcipher/sqlcipher/archive/v3.4.1.tar.gz"
  sha256 "4172cc6e5a79d36e178d36bd5cc467a938e08368952659bcd95eccbaf0fa4ad4"
  revision 1

  head "https://github.com/sqlcipher/sqlcipher.git"

  bottle do
    cellar :any
    sha256 "ba78f0483506f6ca2a6cd77446586f9ee1eb3399bc4b83673b13a89a505846ec" => :sierra
    sha256 "e16f016eb3fa6653defbf9bc00908114772dec88e0131dae32da046d37ca694b" => :el_capitan
    sha256 "093b35376fabba32e8ea42ed8564893a7b5a37ba235b7802449874da0d051c62" => :yosemite
  end

  option "with-fts", "Build with full-text search enabled"

  depends_on "openssl"

  # Upstream SQLite patch for CVE-2017-10989
  patch :p0 do
    url "https://sqlite.org/src/vpatch?from=0db20efe201736b3&to=66de6f4a9504ec26"
    sha256 "41d0570cbf80429e556e612acd5eeddcff0e586264a6bcb80bd5a27abc9159a2"
  end

  def install
    args = %W[
      --prefix=#{prefix}
      --enable-tempstore=yes
      --with-crypto-lib=#{Formula["openssl"].opt_prefix}
      --enable-load-extension
      --disable-tcl
    ]

    if build.with?("fts")
      args << "CFLAGS=-DSQLITE_HAS_CODEC -DSQLITE_ENABLE_FTS3 -DSQLITE_ENABLE_FTS3_PARENTHESIS -DSQLITE_ENABLE_FTS5"
    else
      args << "CFLAGS=-DSQLITE_HAS_CODEC"
    end

    system "./configure", *args
    system "make"
    system "make", "install"
  end
end
