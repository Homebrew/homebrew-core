class Sqlcipher < Formula
  desc "SQLite extension providing 256-bit AES encryption"
  homepage "http://sqlcipher.net"
  url "https://github.com/sqlcipher/sqlcipher/archive/v3.4.1.tar.gz"
  sha256 "4172cc6e5a79d36e178d36bd5cc467a938e08368952659bcd95eccbaf0fa4ad4"
  revision 1

  head "https://github.com/sqlcipher/sqlcipher.git"

  bottle do
    cellar :any
    sha256 "af99accb6d78fc570855dba4e740d0dc873e1e7b53efe1de247e82334d1e21ff" => :sierra
    sha256 "8f0d85daab5aea9effc3c7ae027263f8b72d88ab38ed2c0f613c6eba7c16aeff" => :el_capitan
    sha256 "f8f87d549868829e2825b07b36fd1dfe490be35a0d3aa5b26d1c065631683640" => :yosemite
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
