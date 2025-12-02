class Sqldiff < Formula
  desc "Displays the differences between SQLite databases"
  homepage "https://www.sqlite.org/sqldiff.html"
  url "https://sqlite.org/2025/sqlite-src-3510100.zip"
  version "3.51.1"
  sha256 "0f8e765ac8ea7c36cf8ea9bffdd5c103564f4a8a635f215f9f783b338a13d971"
  license "blessing"

  livecheck do
    formula "sqlite"
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "27204319cf06d8ad0401281e346136472a60667410669dd64557a131692c3c19"
    sha256 cellar: :any,                 arm64_sequoia: "54fba148fc5bf1f03440d54cef5084aa02b9660f2ff4ff64eaad40034608de3c"
    sha256 cellar: :any,                 arm64_sonoma:  "119b8c391d31cb9e1f9bc77197b03cc447cbe882901fc5602174c4ac0c0f4108"
    sha256 cellar: :any,                 tahoe:         "21ff4e0b73c80ee1e95689f2f364f2d6a5a85c79bc4ffed99255ed1d90479f2d"
    sha256 cellar: :any,                 sequoia:       "b8aa95310b7e37610ee8ab0a83af34d1aa6c137e54119361115447d1328d0dea"
    sha256 cellar: :any,                 sonoma:        "ca090b0f7a85af6837cb80682cb8473b914b7e8ab17b28da981c95afd57d8507"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e7d9115f902d7890038ea2355858bf4de3d92fae64e9d01d380cca95d10322b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b02573b58548ad80c77713657e2aa86806fade86db17d9a723c5a68fca13f0c0"
  end

  uses_from_macos "tcl-tk" => :build
  uses_from_macos "sqlite" => :test

  def install
    system "./configure", "--disable-debug", "--prefix=#{prefix}"
    system "make", "sqldiff"
    bin.install "sqldiff"
  end

  test do
    dbpath = testpath/"test.sqlite"
    sqlpath = testpath/"test.sql"
    sqlpath.write "create table test (name text);"
    system "sqlite3 #{dbpath} < #{sqlpath}"
    assert_equal "test: 0 changes, 0 inserts, 0 deletes, 0 unchanged",
                 shell_output("#{bin}/sqldiff --summary #{dbpath} #{dbpath}").strip
  end
end
