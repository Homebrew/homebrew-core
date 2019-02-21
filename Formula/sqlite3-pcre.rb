class Sqlite3Pcre < Formula
  desc "SQLite3 extension using PCRE to provide the REGEXP function"
  homepage "https://github.com/ralight/sqlite3-pcre"
  head "https://github.com/ralight/sqlite3-pcre.git"

  depends_on "coreutils" => :build
  depends_on "pkg-config" => :build
  depends_on "pcre"
  depends_on "sqlite"

  def install
    system "make", "install", "prefix=#{prefix}", "INSTALL=ginstall"
  end

  def caveats; <<~EOS
    sqlite3-pcre does not work with the macOS-provided sqlite3 because it does
    not provide the `.load` meta-command. To invoke the Homebrew-supplied
    keg-only sqlite3, run:
      #{HOMEBREW_PREFIX}/opt/sqlite/bin/sqlite3

    sqlite3 will not automatically load the pcre extension. To load it
    interactively, use this .load command at the sqlite prompt or add it to
    your ~/.sqliterc file:
      .load #{lib}/sqlite3/pcre.so
  EOS
  end

  test do
    system "#{HOMEBREW_PREFIX}/opt/sqlite/bin/sqlite3",
      "-cmd", ".load #{lib}/sqlite3/pcre.so\n",
      "dummy.db", "SELECT 'abba' REGEXP 'ab*a';"
  end
end
