class Sqlcipher < Formula
  desc "SQLite extension providing 256-bit AES encryption"
  homepage "https://www.zetetic.net/sqlcipher/"
  url "https://github.com/sqlcipher/sqlcipher/archive/refs/tags/v4.5.7.tar.gz"
  sha256 "b670845f28da0a3c717e991e9f18a334e08f6bc977190bbce6be864ca229f96d"
  license "BSD-3-Clause"
  head "https://github.com/sqlcipher/sqlcipher.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "e7eba25afbc75a74c0b19654b54f8676042ec1c79f661a04cce1766631b46a53"
    sha256 cellar: :any,                 arm64_ventura:  "0284a513ca90ce57383aa82c464f9a8d538d3bbf649705ce6255eec640e55087"
    sha256 cellar: :any,                 arm64_monterey: "5aa411eca16ea061b7d6ce1b8d76be198d3e651b314349682ebb025f07888b4d"
    sha256 cellar: :any,                 sonoma:         "7ee3f9a4743e58d5d59413a0089173a3b3bc1f49c77da88dfc0bde4d93a9ae75"
    sha256 cellar: :any,                 ventura:        "e8edb9c3132e6bbcc7e15b587411b957bb2192a8d6a304243024ad80b95a6b40"
    sha256 cellar: :any,                 monterey:       "54189020cfce9af7bc8d2b2507bfc7627fece8e21997a04fd0be505df879c45f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3ff8d01a84d2d59626937676ef8a2a01de01a7af4cb719a98fefe12dc0af5e5a"
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
