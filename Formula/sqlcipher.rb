class Sqlcipher < Formula
  desc "SQLite extension providing 256-bit AES encryption"
  homepage "http://sqlcipher.net"
  url "https://github.com/sqlcipher/sqlcipher/archive/v3.4.0.tar.gz"
  sha256 "99b702ecf796de02bf7b7b35de4ceef145f0d62b4467a86707c2d59beea243d0"

  head "https://github.com/sqlcipher/sqlcipher.git"

  bottle do
    cellar :any
    sha256 "7a34ffc2a9ce6284f34d178986bffcfb90c0670620b01a6e44dbd1bd4a7857f6" => :sierra
    sha256 "4bf0216834686577051b6d58aa2b6b2a1c0a91b45831a0c8f07aea9877e2df70" => :el_capitan
    sha256 "0354c675587c3727bf360c1562d87743361045fabca11567ad8e1fff7dd586f4" => :yosemite
    sha256 "ed88417a177ddd5340dd7f04523aa1d444863648a7cd82a3bfa642bc4f5b1992" => :mavericks
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
