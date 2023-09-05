class Sqlcipher < Formula
  desc "SQLite extension providing 256-bit AES encryption"
  homepage "https://www.zetetic.net/sqlcipher/"
  url "https://github.com/sqlcipher/sqlcipher/archive/v4.5.5.tar.gz"
  sha256 "014ef9d4f5b5f4e7af4d93ad399667947bb55e31860e671f0def1b8ae6f05de0"
  license "BSD-3-Clause"
  head "https://github.com/sqlcipher/sqlcipher.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "1e4ebc5947619b99eb3c2c2e835a2337603f8a0c3bff52a70b6818637278b6ab"
    sha256 cellar: :any,                 arm64_monterey: "b5b77288939bca2b377e7beb4be346514b9c18413614f8788ac5d07c78552f94"
    sha256 cellar: :any,                 arm64_big_sur:  "6f1a0befb0ccee32c6c1e67fb191d298d885b9f520732be6e90fd708ccdbcd45"
    sha256 cellar: :any,                 ventura:        "3ca8d6cd2bfa7a5c1462b357d62bcee60f172222245d86f1596db9e770b01733"
    sha256 cellar: :any,                 monterey:       "7b42758d26f57200d12bfd696a4de07a880bf0c2ac13504634096e142a1cb33c"
    sha256 cellar: :any,                 big_sur:        "3753b76ad7f6b6dbfa64da28156a7e36163e7dcad326c8c150c71c0fbe49e803"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e7e1c52561844106e553f74a096873f2f168272f48605dc33f7c8d69cdde0d96"
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
