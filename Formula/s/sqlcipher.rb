class Sqlcipher < Formula
  desc "SQLite extension providing 256-bit AES encryption"
  homepage "https://www.zetetic.net/sqlcipher/"
  url "https://github.com/sqlcipher/sqlcipher/archive/refs/tags/v4.5.6.tar.gz"
  sha256 "e4a527e38e67090c1d2dc41df28270d16c15f7ca5210a3e7ec4c4b8fda36e28f"
  license "BSD-3-Clause"
  head "https://github.com/sqlcipher/sqlcipher.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "cbebb3625c618cf28ed16c0919898a3585349d04588e87530249440375f1e42a"
    sha256 cellar: :any,                 arm64_ventura:  "f135addd49be50b247f1eb2b256708b14207343c122aaa7cb11f3b4ee72fe03d"
    sha256 cellar: :any,                 arm64_monterey: "3b8549d4bdd1cd70166819ddb9922bbcdc28e078ab79fdf09add2eaa47a82024"
    sha256 cellar: :any,                 sonoma:         "a3e5b5994adbe41ba2f1cf7f202adea7e3ea9a6dc0c3fafd9aff462f142ebcf5"
    sha256 cellar: :any,                 ventura:        "ca8f1c4a167bac9ddc17d9445f024af38bc29d5c96b2a5223c197532ea3b0f43"
    sha256 cellar: :any,                 monterey:       "11b3684e158d7b256f3a897f0ca9884f55305cd2a5c0f357abb796844605fbbd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b555e918cd8cf15ec14f4659c1dee0b731528a82b7ca44af382ee9ab2f9f9dd9"
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
