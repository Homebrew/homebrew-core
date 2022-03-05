class Sqlcipher < Formula
  desc "SQLite extension providing 256-bit AES encryption"
  homepage "https://www.zetetic.net/sqlcipher/"
  url "https://github.com/sqlcipher/sqlcipher/archive/v4.5.1.tar.gz"
  sha256 "023499516ef2ade14fbcdbe93fb81cc69458ae6cb3544614df8dbef34835b406"
  license "BSD-3-Clause"
  head "https://github.com/sqlcipher/sqlcipher.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "d1ebc849953fce08b1f64fc5e7ccfafa89637c3427737fea0ffb105255c68939"
    sha256 cellar: :any,                 arm64_big_sur:  "97ceef7f92c22f17d907f9e1aa530b920736c61eabc8355b04d423deac883ab6"
    sha256 cellar: :any,                 monterey:       "e285802456eb8923bffdeb1bffd55fa244a6e0f1a059c4aef0e62dfe0ecfdac0"
    sha256 cellar: :any,                 big_sur:        "1c013e2b27b25ad78a5246879d7ee328fce7375ee7ad67a2fe518ea064be3b2c"
    sha256 cellar: :any,                 catalina:       "ac90cfc14325a2af557d9418d3cf52c74ebda41dab2611aaba3e3e28410252c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "73aef4b1856454a29f3bc8a50ee75a2b36f92548c113cd04031ca22a665bf1ac"
  end

  depends_on "openssl@1.1"

  # Build scripts require tclsh. `--disable-tcl` only skips building extension
  uses_from_macos "tcl-tk" => :build
  uses_from_macos "sqlite"

  def install
    args = %W[
      --prefix=#{prefix}
      --enable-tempstore=yes
      --with-crypto-lib=#{Formula["openssl@1.1"].opt_prefix}
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
