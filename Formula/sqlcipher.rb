class Sqlcipher < Formula
  desc "SQLite extension providing 256-bit AES encryption"
  homepage "https://www.zetetic.net/sqlcipher/"
  url "https://github.com/sqlcipher/sqlcipher/archive/v4.5.2.tar.gz"
  sha256 "6925f012deb5582e39761a7d4816883cc15b41851a8e70b447c223b8ef406e2a"
  license "BSD-3-Clause"
  head "https://github.com/sqlcipher/sqlcipher.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "26df5e279136a5843e9f7058becbf454e2cd7e3c84fa155aadf345abfa1a625d"
    sha256 cellar: :any,                 arm64_monterey: "3485f63912e36d01ecbf4dea5ea11ba0595f5a0d758fe2e50a734da28749429c"
    sha256 cellar: :any,                 arm64_big_sur:  "6a61b33f89fe6517ade5304062b75a4b7fc0e788feeab7e425a29aa437a1f70c"
    sha256 cellar: :any,                 ventura:        "ee001fbdb88863ed67e9dcbd38fe3c3b835b778a40587aa460ea8eebe057268f"
    sha256 cellar: :any,                 monterey:       "28953e908487a25f6e502c299398206639f4542b469b772f85df48d8a578fa44"
    sha256 cellar: :any,                 big_sur:        "9341a568923722c7583fc717037d63aefe941f1d7060c632da4ff2e8fb95a5bd"
    sha256 cellar: :any,                 catalina:       "af5bdb1de84f318ba76ce36f25cc2fe7efbd79798ab06bdc84861ca994a78611"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "40c96980b21b40050833f9db489bf0ae8f4b8bf4b2a711a5f40237be9b727ecf"
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
