class Wal2json < Formula
  desc "Convert PostgreSQL changesets to JSON format"
  homepage "https://github.com/eulerto/wal2json"
  url "https://github.com/eulerto/wal2json/archive/refs/tags/wal2json_2_5.tar.gz"
  sha256 "b516653575541cf221b99cf3f8be9b6821f6dbcfc125675c85f35090f824f00e"
  license "BSD-3-Clause"
  revision 1

  livecheck do
    url :stable
    regex(/(?:wal2json[._-])?v?(\d+(?:[._]\d+)+)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c19c2e4de042773c6197fb1458fa47962f26f440e2275cab182ac1c09c3da014"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4059f538f33c6fe32b73fe86328431027cdbca20ddcd8ac6320fb6a15ac3f8a5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2db7dad2e349f9d37218ddcd6395f14ce6cb1ad7a7a9fe1412ba6926f4f79880"
    sha256 cellar: :any_skip_relocation, sonoma:         "ab113ad5939f77cc2abad6b459ae738d87e7a2f3c7562a50492abb11c9997387"
    sha256 cellar: :any_skip_relocation, ventura:        "2cb542c88e913cf1240457c39f2ad1164d7556834db0588d751652fe10ebea94"
    sha256 cellar: :any_skip_relocation, monterey:       "cdbea4c388aca50b56a4057e4b436a99f2292899444f3dadd1c84a1c23072d1a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "23770f42e994329f5ae2d1e480ce61352a156fac0fe826e341c31605142d922b"
  end

  depends_on "postgresql@14"

  def postgresql
    Formula["postgresql@14"]
  end

  def install
    system "make", "install", "USE_PGXS=1",
                              "PG_CONFIG=#{postgresql.opt_bin}/pg_config",
                              "pkglibdir=#{lib/postgresql.name}"
  end

  test do
    ENV["LC_ALL"] = "C"
    pg_ctl = postgresql.opt_bin/"pg_ctl"
    port = free_port

    system pg_ctl, "initdb", "-D", testpath/"test"
    (testpath/"test/postgresql.conf").write <<~EOS, mode: "a+"

      shared_preload_libraries = 'wal2json'
      port = #{port}
    EOS
    system pg_ctl, "start", "-D", testpath/"test", "-l", testpath/"log"
    system pg_ctl, "stop", "-D", testpath/"test"
  end
end
