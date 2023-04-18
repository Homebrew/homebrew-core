class Sqlcipher < Formula
  desc "SQLite extension providing 256-bit AES encryption"
  homepage "https://www.zetetic.net/sqlcipher/"
  url "https://github.com/sqlcipher/sqlcipher/archive/v4.5.3.tar.gz"
  sha256 "5c9d672eba6be4d05a9a8170f70170e537ae735a09c3de444a8ad629b595d5e2"
  license "BSD-3-Clause"
  head "https://github.com/sqlcipher/sqlcipher.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "0b2668a28a983e347db6939d5b07a870455a6d0873cc546cc698d7a8d35f0bf0"
    sha256 cellar: :any,                 arm64_monterey: "483793504db8ae6a47e51cdbe0f670b6c5af72aeacfc8e868a382f3348f8ea58"
    sha256 cellar: :any,                 arm64_big_sur:  "0534d8aef329ca3e58a2b02f881529dcadc669fc9dabc22f17de609edd67e883"
    sha256 cellar: :any,                 ventura:        "748f7e34c361dd48f209fc3bf6c1d1c81111d5dcf94efde230e790aa278b34af"
    sha256 cellar: :any,                 monterey:       "f3499d7164f0366d45b369e5937b6e5715a4830458a853abcd41fa72d81ea252"
    sha256 cellar: :any,                 big_sur:        "fb3a3e66007caab833719d543ff4dc6e19db0c84df0a156a78fe36fc65efdac8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "25a788e90948b13c89a754bd5d6b075bab0039dc7186c6d77cf2391ff23481fb"
  end

  depends_on "openssl@3"

  # Build scripts require tclsh. `--disable-tcl` only skips building extension
  uses_from_macos "tcl-tk" => :build
  uses_from_macos "sqlite"

  def install
    args = %W[
      --prefix=#{prefix}
      --enable-tempstore=yes
      --with-crypto-lib=#{Formula["openssl@3"].opt_prefix}
      --enable-load-extension
      --disable-tcl
    ]

    # Build with full-text search enabled
    cflags = %w[
      -DSQLITE_HAS_CODEC
      -DSQLITE_ENABLE_JSON1
      -DSQLITE_ENABLE_FTS3
      -DSQLITE_ENABLE_FTS3_PARENTHESIS
      -DSQLITE_ENABLE_FTS5
      -DSQLITE_ENABLE_COLUMN_METADATA
    ].join(" ")
    args << "CFLAGS=#{cflags}"

    args << "LIBS=-lm" if OS.linux?

    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    path = testpath/"school.sql"
    path.write <<~EOS
      create table students (name text, age integer);
      insert into students (name, age) values ('Bob', 14);
      insert into students (name, age) values ('Sue', 12);
      insert into students (name, age) values ('Tim', json_extract('{"age": 13}', '$.age'));
      select name from students order by age asc;
    EOS

    names = shell_output("#{bin}/sqlcipher < #{path}").strip.split("\n")
    assert_equal %w[Sue Tim Bob], names
  end
end
