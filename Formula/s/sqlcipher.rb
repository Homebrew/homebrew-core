class Sqlcipher < Formula
  desc "SQLite extension providing 256-bit AES encryption"
  homepage "https://www.zetetic.net/sqlcipher/"
  url "https://github.com/sqlcipher/sqlcipher/archive/refs/tags/v4.7.0.tar.gz"
  sha256 "59528b5536393772273908edd05f7d66b977cd4226c292aa8bf9fdbc4fb404d9"
  license "BSD-3-Clause"
  head "https://github.com/sqlcipher/sqlcipher.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "2bce86a48eb9ce4e89f10638971fe3e3d338e410c41432f4480866dccc8b8a25"
    sha256 cellar: :any,                 arm64_sonoma:   "ce9815c45580388609c3c3523f8cca865a4a38b809f08a31a786fdefd8829e63"
    sha256 cellar: :any,                 arm64_ventura:  "f52dbcc2f74a793f58fadd7309c2ebe5619aa47ebaedc9285331f5f3c9afd7df"
    sha256 cellar: :any,                 arm64_monterey: "99ceb412afb90b295aa64a1d9ba6bf25bbfb7887b50825154fc8baba3e879874"
    sha256 cellar: :any,                 sonoma:         "14842c50c9074b36748f2d8f8c3e3ba51b6b8dafa4d6c939462ec5d96c0ef5d1"
    sha256 cellar: :any,                 ventura:        "69bdd462ec7b165dfc656e05b206c43b0115754e9a49b3f5a2b3d3e2fa6718d9"
    sha256 cellar: :any,                 monterey:       "69a4c545f99bdd3dee89090c3a264f33d333d4b41be5a368c6a078ea1234fe1f"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "736d4a62c71de3eeda25366f71092586634a4b0b3febc4b8732b9b4f7e8276bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1b698c95084d0ec890fc103429bb615a8c13c87bd13b6a29b246579feb5a0763"
  end

  depends_on "openssl@3"

  # Build scripts require tclsh. `--disable-tcl` only skips building extension
  uses_from_macos "tcl-tk" => :build
  uses_from_macos "sqlite"
  uses_from_macos "zlib"

  def install
    args = %w[
      --with-tempstore=yes
      --enable-load-extension
      --disable-tcl
    ]

    # Build with full-text search enabled
    cflags = %w[
      -DSQLITE_EXTRA_INIT=sqlcipher_extra_init
      -DSQLITE_EXTRA_SHUTDOWN=sqlcipher_extra_shutdown
      -DSQLITE_HAS_CODEC
      -DSQLITE_ENABLE_JSON1
      -DSQLITE_ENABLE_FTS3
      -DSQLITE_ENABLE_FTS3_PARENTHESIS
      -DSQLITE_ENABLE_FTS5
      -DSQLITE_ENABLE_COLUMN_METADATA
    ]

    ldflags = %w[
      -lcrypto
    ]
    ldflags << "-lm" if OS.linux?

    args << "CFLAGS=#{cflags.join(" ")}"
    args << "LDFLAGS=#{ldflags.join(" ")}"

    system "./configure", *args, *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    input = <<~SQL
      create table students (name text, age integer);
      insert into students (name, age) values ('Bob', 14);
      insert into students (name, age) values ('Sue', 12);
      insert into students (name, age) values ('Tim', json_extract('{"age": 13}', '$.age'));
      select name from students order by age asc;
    SQL

    names = pipe_output("#{bin}/sqlite3", input).strip.split("\n")
    assert_equal %w[Sue Tim Bob], names
  end
end
