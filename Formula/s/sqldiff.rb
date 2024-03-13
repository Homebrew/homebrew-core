class Sqldiff < Formula
  desc "Displays the differences between SQLite databases"
  homepage "https://www.sqlite.org/sqldiff.html"
  url "https://www.sqlite.org/2024/sqlite-src-3450200.zip"
  version "3.45.2"
  sha256 "4a45a3577cc8af683c4bd4c6e81a7c782c5b7d5daa06175ea2cb971ca71691b1"
  license "blessing"

  livecheck do
    formula "sqlite"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "684ea88f4c5f8c92de083252375b3552e7bd01239a635a0c36847868629d9abe"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ef6258484c0176763450b4e6520b80e38a3611371a96c98d8f8f2aaa1f25cbb4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "081b64142fe660c6f6e04f6dc85a151e72b76bac5d2384c86f0750af3f2bb257"
    sha256 cellar: :any_skip_relocation, sonoma:         "853f731b2aecb69f1a45722afcf8ac00ff6b12747c4a0a072c2f156e5efc87ef"
    sha256 cellar: :any_skip_relocation, ventura:        "37a2904497c4f4468b71ad87fb5cd42be198eef105bae917f289452835cc57d0"
    sha256 cellar: :any_skip_relocation, monterey:       "5b8e5de8b31a58320b673b16b144a00926b40e23f7e956aa5a075b574c5e1a21"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a6181f82374e18791491095f55090a50ab50f159e70bdf037d1d9078e7ad76b7"
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
