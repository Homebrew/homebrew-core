class Sqldiff < Formula
  desc "Displays the differences between SQLite databases"
  homepage "https://www.sqlite.org/sqldiff.html"
  url "https://www.sqlite.org/2023/sqlite-src-3430200.zip"
  version "3.43.2"
  sha256 "eb6651523f57a5c70f242fc16bc416b81ed02d592639bfb7e099f201e2f9a2d3"
  license "blessing"

  livecheck do
    formula "sqlite"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f4be975109631290ffb0dcedf6cbd7cc30078018c629f4d207f07305ef34be0a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e74dab1dc1672ffe00ddd2cf13d80e8ade3b8183f35156b4e57cd688512be7b9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6edc82ae1bad38ed8818080a5f19cacfa2b9fc463bb6ab45cd802d84ee7248fa"
    sha256 cellar: :any_skip_relocation, sonoma:         "d97774059a22e28d976a7e09737db9c4a531e77cd4ce9c69e0f6fc2cbad4383b"
    sha256 cellar: :any_skip_relocation, ventura:        "e838f2bfcd2c348485d41f20dacbcfdba5b072c5825642ab7eba035c1b5115b8"
    sha256 cellar: :any_skip_relocation, monterey:       "c4430c41be5cd7d944cc1291a9a04d5ae3fa6381cf447c4d4e9c722a6f14d3fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "51c1e7a808cdb7839c3bbe66c2aabb4a42b3f0b88219feb6d0c749bc14a5e167"
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
