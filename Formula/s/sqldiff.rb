class Sqldiff < Formula
  desc "Displays the differences between SQLite databases"
  homepage "https://www.sqlite.org/sqldiff.html"
  url "https://www.sqlite.org/2025/sqlite-src-3500400.zip"
  version "3.50.4"
  sha256 "b7b4dc060f36053902fb65b344bbbed592e64b2291a26ac06fe77eec097850e9"
  license "blessing"

  livecheck do
    formula "sqlite"
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "2295908a8ff92190d9438df8c2b27560d2b87530a27a3fe7ef46e856e6b6d65d"
    sha256 cellar: :any,                 arm64_sequoia: "9d34055313224190d6bcd801ec9a3564dfa4d6c4ae45eb15a406afc3b3dd566e"
    sha256 cellar: :any,                 arm64_sonoma:  "51f603907c351e69382526e83c95de0e8323d587bc6282dfdd52f37edb807ad5"
    sha256 cellar: :any,                 arm64_ventura: "1837dc7e8dc18eda684b620c169945938fe5cc31816eb4012a456477b9e742ed"
    sha256 cellar: :any,                 tahoe:         "be35e774ae7d36f51987bdd57a3888d9d74673a59d067dfb1dd9dae5c9845271"
    sha256 cellar: :any,                 sequoia:       "54ca0752540e90e40b415937d6761e705c0d08da162ba4724e7d78d9caba3361"
    sha256 cellar: :any,                 sonoma:        "b9022ff42dacdce5624ff5cc5167a225eb3c1951257b7562d528160cdcdb0b80"
    sha256 cellar: :any,                 ventura:       "d2032c0717e50f88bec21193dbfe0abc62a94001a856974b16005697b5c24028"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2f3590968b02e558d4e1d174418155a74b1454ac5e253d23541129ee31cc1eff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "14dfcadd7b015800d7b565b57c0068104d3fe73f2d7732d577c7a860976338a1"
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
