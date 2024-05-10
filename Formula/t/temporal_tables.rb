class TemporalTables < Formula
  desc "Temporal Tables PostgreSQL Extension"
  homepage "https://pgxn.org/dist/temporal_tables/"
  url "https://github.com/arkhipov/temporal_tables/archive/refs/tags/v1.2.2.tar.gz"
  sha256 "85517266748a438ab140147cb70d238ca19ad14c5d7acd6007c520d378db662e"
  license "BSD-2-Clause"
  revision 1

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4c329e88b8fa82e9360be732ae2054d0d77b41b29e302636c31f1da2b47203e0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5222d996fc391c50b0b70a096e931c886620e6f538c34d3955bea1fd86f46508"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e458a800f09bb073d81b032e56e6ba124f86a46e8adf7fec9afd5dbfcaee8617"
    sha256 cellar: :any_skip_relocation, sonoma:         "91a343a4100f09bf265f0bb826ecdd610189a5e55fa7349911512a3f5a45c0ab"
    sha256 cellar: :any_skip_relocation, ventura:        "1292cf245c40f3c833b3c05dc4f17d960550107aa4a5df06c8cd8ea77612060b"
    sha256 cellar: :any_skip_relocation, monterey:       "94cfaaa4269a1d3bb894d6eb63c3efb337fd05854a048e47f5d6952a3240d6a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "96fd42f1d03e29962b80bca8ddeb2f25091c810760ee8cbc3163c1b3852e41f9"
  end

  depends_on "postgresql@14"

  def postgresql
    deps.map(&:to_formula)
        .find { |f| f.name.start_with?("postgresql@") }
  end

  def install
    system "make", "install", "PG_CONFIG=#{postgresql.opt_bin}/pg_config",
                              "pkglibdir=#{lib/postgresql.name}",
                              "datadir=#{share/postgresql.name}",
                              "docdir=#{doc}"
  end

  test do
    ENV["LC_ALL"] = "C"
    pg_ctl = postgresql.opt_bin/"pg_ctl"
    psql = postgresql.opt_bin/"psql"
    port = free_port

    system pg_ctl, "initdb", "-D", testpath/"test"
    (testpath/"test/postgresql.conf").write <<~EOS, mode: "a+"

      shared_preload_libraries = 'temporal_tables'
      port = #{port}
    EOS
    system pg_ctl, "start", "-D", testpath/"test", "-l", testpath/"log"
    begin
      system psql, "-p", port.to_s, "-c", "CREATE EXTENSION \"temporal_tables\";", "postgres"
    ensure
      system pg_ctl, "stop", "-D", testpath/"test"
    end
  end
end
