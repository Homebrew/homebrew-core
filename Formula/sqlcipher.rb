class Sqlcipher < Formula
  desc "SQLite extension providing 256-bit AES encryption"
  homepage "http://sqlcipher.net"
  url "https://github.com/sqlcipher/sqlcipher/archive/v3.4.1.tar.gz"
  sha256 "4172cc6e5a79d36e178d36bd5cc467a938e08368952659bcd95eccbaf0fa4ad4"

  head "https://github.com/sqlcipher/sqlcipher.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "186547f2f2bec6166a37b7d57f697fee754c9bce42fe4a1955884c775f472104" => :sierra
    sha256 "7176c5e820b735fdf92b45fef777272b64a3c82a8cd413566a226a51f0d53a26" => :el_capitan
    sha256 "dea950abb96a9072116ef96f6d86eb314908ccee1936b66cc44e7f574eb2c100" => :yosemite
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
      args << "CFLAGS=-DSQLITE_HAS_CODEC -DSQLITE_ENABLE_FTS3 -DSQLITE_ENABLE_FTS3_PARENTHESIS -DSQLITE_ENABLE_FTS5"
    else
      args << "CFLAGS=-DSQLITE_HAS_CODEC"
    end

    system "./configure", *args
    system "make"
    system "make", "install"
  end
end
