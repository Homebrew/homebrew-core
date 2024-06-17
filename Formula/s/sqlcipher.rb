class Sqlcipher < Formula
  desc "SQLite extension providing 256-bit AES encryption"
  homepage "https://www.zetetic.net/sqlcipher/"
  url "https://github.com/sqlcipher/sqlcipher/archive/refs/tags/v4.6.0.tar.gz"
  sha256 "879fb030c36bc5138029af6aa3ae3f36c28c58e920af05ac7ca78a5915b2fa3c"
  license "BSD-3-Clause"
  head "https://github.com/sqlcipher/sqlcipher.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "066c9f17f15ee360aa64baf7c1189e3e6931cee28b6ead023e779150a3cfb813"
    sha256 cellar: :any,                 arm64_ventura:  "7453973a34facdcb7fd98bdde53955686021c6a1dffab50dd4a229ed610b2131"
    sha256 cellar: :any,                 arm64_monterey: "618500314eb6ef0ca989541b3606a7175056683ff54bede42735d231ba298a1f"
    sha256 cellar: :any,                 sonoma:         "9f0ae29d495f35636c928b5b03a403c6046d50204e6b8c5c285fa1f83ab99fef"
    sha256 cellar: :any,                 ventura:        "5e4b2cc9a69dc2b00a49044ee693898e12a59ec57622237abc7da2d683dfd3ff"
    sha256 cellar: :any,                 monterey:       "8dff54227f63f32d8cf26b08cecd6827d4b8ca6e88d049cf3a46c42154e3f0cb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "44c92cf4a3768a35bd7c8bc7f99c183ac00227d6db4b9cd8c5db2b4d136da8b2"
  end

  depends_on "openssl@3"

  # Build scripts require tclsh. `--disable-tcl` only skips building extension
  uses_from_macos "tcl-tk" => :build
  uses_from_macos "sqlite"
  uses_from_macos "zlib"

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
